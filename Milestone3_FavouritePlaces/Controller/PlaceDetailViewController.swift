//
//  PlaceDetailViewController.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 7/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PlaceDetailViewController: UITableViewController, UITextFieldDelegate, MKMapViewDelegate {
    /// The Place object passed from the master view.
    var place: Place?
    
    /// A copy of the Place object.
    var placeCopy: Place?
    
    ///
    weak var delegate: FavouritePlacesDelegate?
    
    /// The timezone of the users device.
    let timeZone = 10

    /// Place name text field.
    @IBOutlet weak var placeNameTextField: UITextField!
    
    /// Place address text field.
    @IBOutlet weak var placeAddressTextField: UITextField!
    
    /// Place latitude text field.
    @IBOutlet weak var placeLatitudeTextField: UITextField!
    
    /// Place longitude text field.
    @IBOutlet weak var placeLongitudeTextField: UITextField!
    
    /// Place's sunrise time label.
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    
    /// Place's midday time label.
    @IBOutlet weak var middayTimeLabel: UILabel!
    
    /// Place's sunset time label.
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    
    /// Place's twilight time label.
    @IBOutlet weak var twilightTimeLabel: UILabel!
    
    /// Date picker.
    @IBOutlet weak var datePicker: UIDatePicker!
    
    /// Place's weather date label.
    @IBOutlet weak var weatherDateLabel: UILabel!
    
    /// Place's low temperature label.
    @IBOutlet weak var lowTempLabel: UILabel!
    
    /// Place's high temperature label.
    @IBOutlet weak var highTempLabel: UILabel!
    
    /// Place's day length label.
    @IBOutlet weak var dayLengthLabel: UILabel!
    
    /// Place's weather type label.
    @IBOutlet weak var weatherTypeLabel: UILabel!
    
    /// Image view to display weather type.
    @IBOutlet weak var weatherTypeImage: UIImageView!
    
    /// Map view to display the Place.
    @IBOutlet weak var placeMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        displayPlace()
        setupCancelButton()
        placeMapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPinAnnotation)))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !isInSplitView() {
            save()
        }
    }
    
    /// Sets up the text fields.
    func setupTextFields() {
        let textFields = getAllTextFields()
        for textField in textFields {
            textField.delegate = self
        }
    }
    
    /// Gets all text fields that can be edited.
    /// - Returns: Array of editable text fields.
    func getAllTextFields() -> [UITextField] {
        return [placeNameTextField, placeAddressTextField, placeLatitudeTextField, placeLongitudeTextField]
    }
    
    /// Asks the text field delegate if the text field is returnable.
    /// - Parameters:
    ///     - textField: The text field querying the delegate.
    /// - Returns: true if the text field is returnable.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// Sets up the cancel button.
    func setupCancelButton() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = cancelButton
    }

    /// Handles when the placeNameTextField has finished being edited.
    @IBAction func placeNameTextFieldFinishedEditing(_ sender: Any) {
        if hasPlaceInformation() && isInSplitView() {
            save()
        }
    }
    
    /// Handles when the date picker date is changed.
    /// - Parameters:
    ///     - sender: The date picker object.
    @IBAction func datePickerDateChanged(_ sender: Any) {
        guard let place = place else { return }
        let date = getFormattedDate()
        if place.getWeather(date) == nil {
            getWeatherInformation(getCityFromAddressString(place.getAddress()))
        } else {
            displayWeather(place)
        }
        if place.getSunriseAndSunsetTimes(date) == nil {
            getSunriseAndSunsetTimes(place.getLatitude(), place.getLongitude())
        } else {
            displaySunriseAndSunset(place)
        }
    }
    
    /// Checks to see if all the information need for a Place object has been input.
    /// - Returns: true if all infomration has been input.
    func hasPlaceInformation() -> Bool {
        guard let name = placeNameTextField.text, let address = placeAddressTextField.text, let latitude = placeLatitudeTextField.text, let longitude = placeLongitudeTextField.text else { return false }
        return name != "" && address != "" && latitude != "" && longitude != ""
    }
    
    /// Checks if the display is in split view.
    /// - Returns: true if the display is in split view.
    func isInSplitView() -> Bool {
        guard let isCollapsed = splitViewController?.isCollapsed else { return false }
        return !isCollapsed
    }
    
    /// Handles saving changes made to the Place object.
    func save() {
        guard let place = place else { return }
        if isInSplitView() {
            updatePlaceCopy(place)
        }
        place.setName(getPlaceName())
        place.setAddress(getPlaceAddress())
        place.setLatitude(getPlaceLatitude())
        place.setLongitude(getPlaceLongitude())
        delegate?.save()
    }
    
    /// Updates the Place object to the last saved version.
    /// - Parameters:
    ///     - place: The object to copy.
    func updatePlaceCopy(_ place: Place) {
        guard let placeCopy = placeCopy else { return }
        placeCopy.setName(place.getName())
        placeCopy.setAddress(place.getAddress())
        placeCopy.setLatitude(place.getLatitude())
        placeCopy.setLongitude(place.getLongitude())
    }
    
    /// Handles when the address text field has finished being edited.
    @IBAction func addressTextFieldFinishedEditing(_ sender: Any) {
        guard let address = placeAddressTextField.text else { return }
        if placeLatitudeTextField.text == "" && placeLongitudeTextField.text == "" {
            GeoLocation(address).request() { [weak self] in
                guard let this = self, let location = $0.location, let city = $0.locality else { return }
                this.placeLatitudeTextField.text = "\(location.coordinate.latitude)"
                this.placeLongitudeTextField.text = "\(location.coordinate.longitude)"
                this.getSunriseAndSunsetTimes(location.coordinate.latitude, location.coordinate.longitude)
                this.getWeatherInformation(city)
                this.addPlaceAnnotation(location.coordinate.latitude, location.coordinate.longitude)
                if this.hasPlaceInformation() && this.isInSplitView() {
                    this.save()
                }
            }
        }
    }
    
    /// Extracts the Place's city from its address.
    /// - Parameters:
    ///     - address: The Place's address.
    /// - Returns: The Place's city.
    func getCityFromAddressString(_ address: String) -> String {
        let addressSplit = address.split(separator: ",")
        return String(addressSplit[1])
    }
    
    /// Checks if the weather labels contain data.
    /// - Returns: true if the labels contain data.
    func weatherIsEmpty() -> Bool {
        return weatherTypeLabel.text == "" && weatherDateLabel.text == "" && lowTempLabel.text == "" && highTempLabel.text == ""
    }
    
    /// Handles when the place latitude text field has finished being edited.
    @IBAction func placeLatitudeTextFieldFinishedEditing(_ sender: Any) {
        if canReverseGeoLookup() {
            reverseGeoLookup()
        }
    }
    /// Handles when the place latitude text field value has changed.
    @IBAction func placeLatitudeTextFieldChanged(_ sender: Any) {
        if !hasSunriseAndSunsetTimes() && !isLocationEmpty() {
            getSunriseAndSunsetTimes(getPlaceLatitude(), getPlaceLongitude())
        }
    }
    
    // MARK : - Textfield getters
    
    /// Gets the text that is in the place name text field.
    /// - Returns: The name of the Place.
    func getPlaceName() -> String {
        guard let name = placeNameTextField.text else { return "" }
        return name
    }
    
    /// Gets the text that is in the address text field.
    /// - Returns: The address of the Place.
    func getPlaceAddress() -> String {
        guard let address = placeAddressTextField.text else { return "" }
        return address
    }
    
    /// Gets the text that is in the latitude text field.
    /// - Returns: The latitude of the Place.
    func getPlaceLatitude() -> Double {
        guard let latText = placeLatitudeTextField.text, let latitude = Double(latText) else { return 0 }
        return latitude
    }
    
    /// Gets the text that is in the longitude text field.
    /// - Returns: The longitude of the Place.
    func getPlaceLongitude() -> Double {
        guard let lonText = placeLongitudeTextField.text, let longitude = Double(lonText) else { return 0 }
        return longitude
    }
    
    /// Handles when the place longitude text field has finished being edited.
    @IBAction func placeLongitudeTextFieldFinishedEditing(_ sender: Any) {
        if canReverseGeoLookup() {
            reverseGeoLookup()
        }
    }
    
    /// Handles when the place longitude text field value has changed.
    @IBAction func placeLongitudeTextFieldChanged(_ sender: Any) {
        if !hasSunriseAndSunsetTimes() && !isLocationEmpty() {
            getSunriseAndSunsetTimes(getPlaceLongitude(), getPlaceLongitude())
        }
    }
    
    /// Checks if the location text fields are empty.
    /// - Returns: true if the location fields are empty.
    func isLocationEmpty() -> Bool {
        return placeLongitudeTextField.text == "" && placeLatitudeTextField.text == ""
    }
    
    /// Checks if the Place object has sunrise and sunset times for the current date displayed by the date picker.
    /// - Returns: true if the Place has sunrise and sunset data for the date.
    func hasSunriseAndSunsetTimes() -> Bool {
        let date = getFormattedDate()
        guard let place = place, place.getSunriseAndSunsetTimes(date) != nil else { return false }
        return true
    }
    
    /// Checks if the Place object has weather information for the current date displayed by the date picker.
    /// - Returns: true if the Place has weather information for the date.
    func hasWeatherInformation() -> Bool {
        let date = getFormattedDate()
        guard let place = place, place.getWeather(date) != nil else { return false }
        return true
    }
    
    
    func getUserInput(_ textField: UITextField) -> UserInput? {
        guard let contentType = textField.textContentType, let field = textField.accessibilityIdentifier, let value = textField.text else  { return nil }
        return UserInput(contentType: contentType.rawValue, field: field, value: value)
    }
    
    /// Checks whether reverse geolocation lookup can be executed.
    /// - Returns: true if reverse geolocation lookup can be executed.
    func canReverseGeoLookup() -> Bool {
        guard let address = placeAddressTextField.text, let latitude = placeLatitudeTextField.text, let longitude = placeLongitudeTextField.text else { return false }
        return address.isEmpty && !latitude.isEmpty && !longitude.isEmpty
    }
    
    /// Does reverse geolocation lookup if it can or should be done.
    func reverseGeoLookup() {
        guard let latText = placeLatitudeTextField.text, let lonText = placeLongitudeTextField.text, let latitude = Double(latText), let longitude = Double(lonText) else { return }
        GeoLocation(latitude, longitude).request() { [weak self] in
            guard let address = $0.name, let city = $0.locality, let state = $0.administrativeArea ,let this = self else { return }
            this.placeAddressTextField.text = "\(address), \(city), \(state)"
            if this.hasPlaceInformation() && this.isInSplitView() {
                this.save()
            }
            this.getWeatherInformation(city)
        }
        getSunriseAndSunsetTimes(latitude, longitude)
        addPlaceAnnotation(latitude, longitude)
    }
    
    /// Handles the request of sunrise and sunset times.
    /// - Parameters:
    ///     - latitude: The latitdue of the Place.
    ///     - longitude: The longitude of the Place.
    func getSunriseAndSunsetTimes(_ latitude: Double, _ longitude: Double) {
        SunriseSunsetAPI(latitude, longitude, getFormattedDate()).request() {
            guard let sunriseAndSunsetTimes = $0 else { return }
            DispatchQueue.main.async { [weak self] in
                guard let this = self, let place = this.place else { return }
                this.sunriseTimeLabel.text = this.utcToGmt(sunriseAndSunsetTimes.sunrise, this.timeZone)
                this.middayTimeLabel.text = this.utcToGmt(sunriseAndSunsetTimes.midday, this.timeZone)
                this.sunsetTimeLabel.text = this.utcToGmt(sunriseAndSunsetTimes.sunset, this.timeZone)
                this.twilightTimeLabel.text = this.utcToGmt(sunriseAndSunsetTimes.twilight, this.timeZone)
                this.dayLengthLabel.text = "Day Length: \(sunriseAndSunsetTimes.dayLength)"
                place.addSunriseAndSunsetTimes(this.getFormattedDate(), sunriseAndSunset: sunriseAndSunsetTimes)
                if this.isInSplitView() {
                    this.delegate?.save()
                }
            }
        }
    }
    
    /// As the time returned by sunrise-sunset API is in UTC, it is converted to GMT + 10
    /// - Parameters:
    ///     - time: The time to be converted
    ///     - timeZone: The timezone convert to.
    /// - Returns: The converted time.
    func utcToGmt(_ time: String, _ timeZone: Int) -> String {
        let hoursAndMinutes = time.split(separator: ":")
        let secondsAndTimePeriod = hoursAndMinutes[2].split(separator: " ")
        guard var hours = Int(hoursAndMinutes[0]), let minutes = Int(hoursAndMinutes[1]), let seconds = Int(secondsAndTimePeriod[0]) else { return "" }
        let timePeriod = secondsAndTimePeriod[1]
        let hoursInTwentyFourHourTime = timePeriod == "PM" ? (hours + 12) + timeZone : hours + timeZone
        hours = hoursInTwentyFourHourTime > 24 ? hoursInTwentyFourHourTime - 24 : hoursInTwentyFourHourTime > 12 ? hoursInTwentyFourHourTime - 12 : hoursInTwentyFourHourTime
        return "\(hours):\(minutes < 10 ? "0\(minutes)" : "\(minutes)"):\(seconds < 10 ? "0\(seconds)" : "\(seconds)") \(hoursInTwentyFourHourTime < 12 || hoursInTwentyFourHourTime > 24 ? "AM" : "PM")"
    }
    
    /// Handles the request of weather information
    /// - Parameters:
    ///     - cityName: The city to get the weather informatino for.
    func getWeatherInformation(_ cityName: String) {
        WeatherAPI(cityName).request() { [weak self] in
            let weather = $0
            DispatchQueue.main.async {
                guard let this = self, let place = this.place else { return }
                this.weatherDateLabel.text = this.getFormattedDate()
                this.weatherTypeLabel.text = weather.weather[0].description
                this.weatherTypeImage.image = UIImage(imageLiteralResourceName: weather.weather[0].getImageString())
                this.lowTempLabel.text = "\(this.kelvinToCelsius(weather.main.minTemperature)) ºC"
                this.highTempLabel.text = "\(this.kelvinToCelsius(weather.main.maxTemperature)) ºC"
                place.addWeather(this.getFormattedDate(), weather: weather)
                if this.isInSplitView() {
                    this.delegate?.save()
                }
            }
        }
    }
    
    /// Checks if the date is yesterday, today, or tomorrow and displays that if so.
    /// - Parameters:
    ///     - date: The date to check.
    /// - Returns: Yesterday, Today, or Tomorrow if the weather information is for those days based on current date, otherwise returns date in YYYY-MM-dd format.
    func todayAndTomorrowDateCheck(_ date: String) -> String {
        let currentDate = Date()
        let splitDate = date.split(separator: "-")
        guard let year = Int(splitDate[0]), let month = Int(splitDate[1]), let day = Int(splitDate[2]) else { return "" }
        let calendar = Calendar.current
        if year == calendar.component(.year, from: currentDate) && month == calendar.component(.month, from: currentDate) && day == calendar.component(.day, from: currentDate) {
            return "Today"
        } else if year == calendar.component(.year, from: currentDate) && month == calendar.component(.month, from: currentDate) && day == calendar.component(.day, from: currentDate) + 1 {
            return "Tomorrow"
        } else if year == calendar.component(.year, from: currentDate) && month == calendar.component(.month, from: currentDate) && day == calendar.component(.day, from: currentDate) - 1 {
            return "Yesterday"
        }
        return date
    }
    
    // MARK: - Display functions
    
    /// Displays the information of the Place object.
    func displayPlace() {
        guard let place = place else { return }
        placeNameTextField.text = place.getName()
        placeAddressTextField.text = place.getAddress()
        placeLatitudeTextField.text = place.getLatitude() == 0.0 ? "" : "\(place.getLatitude())"
        placeLongitudeTextField.text = place.getLongitude() == 0.0 ? "" : "\(place.getLongitude())"
        makeCopy(place)
        if place.getName() != "" {
            addPlaceAnnotation(place.getLatitude(), place.getLongitude())
            if hasApiInformation(place) {
                displaySunriseAndSunset(place)
                displayWeather(place)
            } else {
                getWeatherInformation(getCityFromAddressString(place.getAddress()))
                getSunriseAndSunsetTimes(place.getLatitude(), place.getLongitude())
            }
        }
    }
    
    /// Checks if the Place object has API data for the current date.
    /// - Parameters:
    ///     - place: The place object to check.
    /// - Returns: true if the Place has the API information stored.
    func hasApiInformation(_ place: Place) -> Bool {
        let date = getFormattedDate()
        guard let _ = place.getSunriseAndSunsetTimes(date), let _ = place.getWeather(date) else { return false }
        return true
    }
    
    /// Gets a formatted date based on the value of the date picker.
    /// - Returns: Date string formatted to YYYY-MM-dd
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600 * 10)
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: datePicker.date)
    }
    
    /// Displays the sunrise and sunset information if it is stored.
    /// - Parameters:
    ///     - place: The Place object to get the sunrise and sunset information.
    func displaySunriseAndSunset(_ place: Place) {
        let date = getFormattedDate()
        guard let sunriseAndSunset = place.getSunriseAndSunsetTimes(date) else { return }
        sunriseTimeLabel.text = utcToGmt(sunriseAndSunset.sunrise, timeZone)
        middayTimeLabel.text = utcToGmt(sunriseAndSunset.midday, timeZone)
        sunsetTimeLabel.text = utcToGmt(sunriseAndSunset.sunset, timeZone)
        twilightTimeLabel.text = utcToGmt(sunriseAndSunset.twilight, timeZone)
        dayLengthLabel.text = "Day Length: \(sunriseAndSunset.dayLength)"
    }
    
    /// Displays the weather infomration if it is stored.
    /// - Parameters:
    ///     - place: The Place object to get the weather information.
    func displayWeather(_ place: Place) {
        let date = getFormattedDate()
        guard let weather = place.getWeather(date) else { return }
        lowTempLabel.text = "\(kelvinToCelsius(weather.main.minTemperature)) ºC"
        highTempLabel.text = "\(kelvinToCelsius(weather.main.maxTemperature)) ºC"
        weatherDateLabel.text = todayAndTomorrowDateCheck(date)
        weatherTypeLabel.text = weather.weather[0].description
        weatherTypeImage.image = UIImage(imageLiteralResourceName: weather.weather[0].getImageString())
    }
    
    /// Adds an annotation to the map view based on the latitude and longitude of the Place.
    /// - Parameters:
    ///     - latitude: The latitude of the Place.
    ///     - longitude: The longitude of the Place.
    func addPlaceAnnotation(_ latitude: Double, _ longitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        placeMapView.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            guard let this = self else { return }
            this.placeMapView.removeAnnotations(this.placeMapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            if let place = this.place {
                annotation.title = place.getName()
                annotation.subtitle = place.getAddress()
            } else {
                annotation.title = this.getPlaceName()
                annotation.subtitle = this.getPlaceAddress()
            }
            this.placeMapView.addAnnotation(annotation)
        }
    }

    /// Adds another pin to the map view if the user selects a different location.
    @objc
    func addPinAnnotation(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: placeMapView)
        let coordinates = placeMapView.convert(tapLocation, toCoordinateFrom: placeMapView)
        GeoLocation(coordinates.latitude, coordinates.longitude).request() { [weak self] in
            guard let this = self, let place = this.place else { return }
            if place.getLatitude() != coordinates.latitude && place.getLongitude() != coordinates.longitude {
                this.updatePlaceDetails(place, $0)
            }
        }
    }
    
    /// If the user adds a pin to the map view, the Place is updated to the information of that newly added pin.
    /// - Parameters:
    ///     - place: The Place object to update.
    ///     - placeDetails: The details of the place indicated by the pin.
    func updatePlaceDetails(_ place: Place, _ placeDetails: CLPlacemark) {
        guard let location = placeDetails.location, let address = placeDetails.name, let city = placeDetails.locality, let state = placeDetails.administrativeArea else { return }
        updatePlaceCopy(place)
        place.setName(getPlaceName())
        place.setLatitude(location.coordinate.latitude)
        place.setLongitude(location.coordinate.longitude)
        place.setAddress("\(address), \(city), \(state)")
        displayPlace()
        if isInSplitView() {
            save()
        }
    }
    
    /// As the temperatures returned by the openweathermap.org API is in kelvin it is converted to celsius.
    /// - Parameters:
    ///     - temperature: The temperature in kelvin.
    /// - Returns: The temperature in celsius.
    func kelvinToCelsius(_ temperature: Double) -> Int {
        return Int(temperature - 273.15)
    }
    
    /// Makes a copy of the Place object being used.
    func makeCopy(_ place: Place) {
        guard placeCopy == nil else { return }
        placeCopy = Place(place.getName(), place.getAddress(), place.getLatitude(), place.getLongitude())
    }
    
    /// Handles the pressing of the cancel button.
    @objc
    func cancelButtonPressed(_ sender: UIBarButtonItem) {
        cancel()
    }
    
    /// If the copy has default information it is deleted, otherwise reverted back to the values held in the copy.
    func cancel() {
        guard let place = place, let placeCopy = placeCopy else { return }
        if placeCopy.getName() != "" {
            revertToCopy(placeCopy)
            displayPlace()
            save()
        } else {
            revertToCopy(placeCopy)
            delegate?.delete(place)
        }
    }
    
    /// Reverts any changes made back to the stored copy.
    /// - Parameters:
    ///     - copy: The Place copy to revert too.
    func revertToCopy(_ copy: Place) {
        guard let place = place else { return }
        place.setName(copy.getName())
        place.setAddress(copy.getAddress())
        place.setLatitude(copy.getLatitude())
        place.setLongitude(copy.getLongitude())
    }
}
