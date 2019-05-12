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
    var place: Place?
    var placeCopy: Place?
    weak var delegate: PhoneDelegate?
    let headerTitles = ["Name And Address", "Location","Date", "Sunrise And Sunset" ,"Weather", "Map"]

    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placeAddressTextField: UITextField!
    @IBOutlet weak var placeLatitudeTextField: UITextField!
    @IBOutlet weak var placeLongitudeTextField: UITextField!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var middayTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var twilightTimeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var weatherDateLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var dayLengthLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var weatherTypeImage: UIImageView!
    @IBOutlet weak var placeMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        displayPlace()
        setupCancelButton()
        checkApiData()
        placeMapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPinAnnotation)))
    }
    
    func checkApiData() {
        guard let place = place else { return }
        place.printSunriseAndWeather()
    }
    
    func setupTextFields() {
        let textFields = getAllTextFields()
        for textField in textFields {
            textField.delegate = self
        }
    }
    
    func getAllTextFields() -> [UITextField] {
        return [placeNameTextField, placeAddressTextField, placeLatitudeTextField, placeLongitudeTextField]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupCancelButton() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = cancelButton
    }

    @IBAction func placeNameTextFieldFinishedEditing(_ sender: Any) {
        if hasPlaceInformation() && isInSplitView() {
            save()
        }
    }
    
    func hasPlaceInformation() -> Bool {
        guard let name = placeNameTextField.text, let address = placeAddressTextField.text, let latitude = placeLatitudeTextField.text, let longitude = placeLongitudeTextField.text else { return false }
        return name != "" && address != "" && latitude != "" && longitude != ""
    }
    
    func isInSplitView() -> Bool {
        guard let isCollapsed = splitViewController?.isCollapsed else { return false }
        return !isCollapsed
    }
    
    func save() {
        guard let place = place, let name = placeNameTextField.text, let address = placeAddressTextField.text else { return }
        place.setName(name)
        place.setAddress(address)
        place.setLatitude(getPlaceLatitude())
        place.setLongitude(getPlaceLongitude())
        delegate?.save()
    }
    
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
                if this.hasPlaceInformation() {
                    this.save()
                }
            }
        }
    }
    
    func weatherIsEmpty() -> Bool {
        return weatherTypeLabel.text == "" && weatherDateLabel.text == "" && lowTempLabel.text == "" && highTempLabel.text == ""
    }
    
    @IBAction func placeLatitudeTextFieldFinishedEditing(_ sender: Any) {
        if canReverseGeoLookup() {
            reverseGeoLookup()
        }
    }
    
    @IBAction func placeLatitudeTextFieldChanged(_ sender: Any) {
        if !hasSunriseAndSunsetTimes() && !isLocationEmpty() {
            getSunriseAndSunsetTimes(getPlaceLatitude(), getPlaceLongitude())
        }
    }
    
    func getPlaceLatitude() -> Double {
        guard let latText = placeLatitudeTextField.text, let latitude = Double(latText) else { return 0 }
        return latitude
    }
    
    func getPlaceLongitude() -> Double {
        guard let lonText = placeLongitudeTextField.text, let longitude = Double(lonText) else { return 0 }
        return longitude
    }
    
    @IBAction func placeLongitudeTextFieldFinishedEditing(_ sender: Any) {
        if canReverseGeoLookup() {
            reverseGeoLookup()
        }
    }
    
    @IBAction func placeLongitudeTextFieldChanged(_ sender: Any) {
        if !hasSunriseAndSunsetTimes() && !isLocationEmpty() {
            getSunriseAndSunsetTimes(getPlaceLongitude(), getPlaceLongitude())
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == placeLatitudeTextField || textField == placeLongitudeTextField {
            print("changed latitude or longitude")
            return true
        }
        return true
    }
    
    func isLocationEmpty() -> Bool {
        return placeLongitudeTextField.text == "" && placeLatitudeTextField.text == ""
    }
    
    func hasSunriseAndSunsetTimes() -> Bool {
        let date = getFormattedDate()
        guard let place = place, place.getSunriseAndSunsetTimes(date) != nil else { return false }
        return true
    }
    
    func hasWeatherInformation() -> Bool {
        let date = getFormattedDate()
        guard let place = place, place.getWeather(date) != nil else { return false }
        return true
    }
    
    
    func getUserInput(_ textField: UITextField) -> UserInput? {
        guard let contentType = textField.textContentType, let field = textField.accessibilityIdentifier, let value = textField.text else  { return nil }
        return UserInput(contentType: contentType.rawValue, field: field, value: value)
    }
    
    func canReverseGeoLookup() -> Bool {
        guard let address = placeAddressTextField.text, let latitude = placeLatitudeTextField.text, let longitude = placeLongitudeTextField.text else { return false }
        return address.isEmpty && !latitude.isEmpty && !longitude.isEmpty
    }
    
    func reverseGeoLookup() {
        guard let latText = placeLatitudeTextField.text, let lonText = placeLongitudeTextField.text, let latitude = Double(latText), let longitude = Double(lonText) else { return }
        GeoLocation(latitude, longitude).request() { [weak self] in
            guard let name = $0.locality, let this = self else { return }
            this.placeAddressTextField.text = name
            if this.hasPlaceInformation() {
                this.save()
            }
            this.getWeatherInformation(name)
        }
        getSunriseAndSunsetTimes(latitude, longitude)
        addPlaceAnnotation(latitude, longitude)
    }
    
    func getSunriseAndSunsetTimes(_ latitude: Double, _ longitude: Double) {
        SunriseSunsetAPI(latitude, longitude, getFormattedDate()).request() {
            guard let sunriseAndSunsetTimes = $0 else { return }
            DispatchQueue.main.async { [weak self] in
                guard let this = self, let place = this.place else { return }
                let usersTimeZone = 10
                this.sunriseTimeLabel.text = this.utcToGmt(sunriseAndSunsetTimes.sunrise, usersTimeZone)
                this.middayTimeLabel.text = this.utcToGmt(sunriseAndSunsetTimes.midday, usersTimeZone)
                this.sunsetTimeLabel.text = this.utcToGmt(sunriseAndSunsetTimes.sunset, usersTimeZone)
                this.twilightTimeLabel.text = this.utcToGmt(sunriseAndSunsetTimes.twilight, usersTimeZone)
                this.dayLengthLabel.text = "Day Length: \(sunriseAndSunsetTimes.dayLength)"
                place.addSunriseAndSunsetTimes(this.getFormattedDate(), sunriseAndSunset: sunriseAndSunsetTimes)
                this.delegate?.save()
            }
        }
    }
    
    func utcToGmt(_ time: String, _ timeZone: Int) -> String {
        let hoursAndMinutes = time.split(separator: ":")
        let secondsAndTimePeriod = hoursAndMinutes[2].split(separator: " ")
        guard var hours = Int(hoursAndMinutes[0]), let minutes = Int(hoursAndMinutes[1]), let seconds = Int(secondsAndTimePeriod[0]) else { return "" }
        let timePeriod = secondsAndTimePeriod[1]
        let hoursInTwentyFourHourTime = timePeriod == "PM" ? (hours + 12) + timeZone : hours + timeZone
        hours = hoursInTwentyFourHourTime > 24 ? hoursInTwentyFourHourTime - 24 : hoursInTwentyFourHourTime > 12 ? hoursInTwentyFourHourTime - 12 : hoursInTwentyFourHourTime
        return "\(hours):\(minutes < 10 ? "0\(minutes)" : "\(minutes)"):\(seconds < 10 ? "0\(seconds)" : "\(seconds)") \(hoursInTwentyFourHourTime < 12 || hoursInTwentyFourHourTime > 24 ? "AM" : "PM")"
    }
    
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
                this.delegate?.save()
            }
        }
    }
    
    func todayAndTomorrowDateCheck(_ date: String) -> String {
        let currentDate = Date()
        let splitDate = date.split(separator: "-")
        guard let year = Int(splitDate[0]), let month = Int(splitDate[1]), let day = Int(splitDate[2]) else { return "" }
        let calendar = Calendar.current
        if year == calendar.component(.year, from: currentDate) && month == calendar.component(.month, from: currentDate) && day == calendar.component(.day, from: currentDate) {
            return "Today"
        } else if year == calendar.component(.year, from: currentDate) + 1 && month == calendar.component(.month, from: currentDate) + 1 && day == calendar.component(.day, from: currentDate) + 1 {
            return "Tomorrow"
        } else if year == calendar.component(.year, from: currentDate) - 1 && month == calendar.component(.month, from: currentDate) - 1 && day == calendar.component(.day, from: currentDate) {
            return "Yesterday"
        }
        return date
    }
    
    // MARK: - Display functions
    
    func displayPlace() {
        guard let place = place else { return }
        placeNameTextField.text = place.getName()
        placeAddressTextField.text = place.getAddress()
        placeLatitudeTextField.text = place.getLatitude() == 0.0 ? "" : "\(place.getLatitude())"
        placeLongitudeTextField.text = place.getLongitude() == 0.0 ? "" : "\(place.getLongitude())"
        if hasApiInformation(place) {
            displaySunriseAndSunset(place)
            displayWeather(place)
            addPlaceAnnotation(place.getLatitude(), place.getLongitude())
        }
        makeCopy(place)
    }
    
    func hasApiInformation(_ place: Place) -> Bool {
        let date = getFormattedDate()
        guard let _ = place.getSunriseAndSunsetTimes(date), let _ = place.getWeather(date) else { return false }
        return true
    }
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600 * 10)
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: datePicker.date)
    }
    
    func displaySunriseAndSunset(_ place: Place) {
        let date = getFormattedDate()
        guard let sunriseAndSunset = place.getSunriseAndSunsetTimes(date) else { return }
        sunriseTimeLabel.text = sunriseAndSunset.sunrise
        middayTimeLabel.text = sunriseAndSunset.midday
        sunsetTimeLabel.text = sunriseAndSunset.sunset
        twilightTimeLabel.text = sunriseAndSunset.twilight
        dayLengthLabel.text = "Day Length: \(sunriseAndSunset.dayLength)"
    }
    
    func displayWeather(_ place: Place) {
        let date = getFormattedDate()
        guard let weather = place.getWeather(date) else { return }
        lowTempLabel.text = "\(kelvinToCelsius(weather.main.minTemperature)) ºC"
        highTempLabel.text = "\(kelvinToCelsius(weather.main.maxTemperature)) ºC"
        weatherTypeLabel.text = weather.weather[0].description
        weatherTypeImage.image = UIImage(imageLiteralResourceName: weather.weather[0].getImageString())
    }
    
    func addPlaceAnnotation(_ latitude: Double, _ longitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        placeMapView.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) { [weak self] in
            guard let this = self else { return }
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            if let place = this.place {
                annotation.title = place.getName()
                annotation.subtitle = place.getAddress()
            } else {
                guard let name = this.placeNameTextField.text, let address = this.placeAddressTextField.text else { return }
                annotation.title = name
                annotation.subtitle = address
            }
            this.placeMapView.addAnnotation(annotation)
        }
    }

    @objc
    func addPinAnnotation(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: placeMapView)
        let coordinates = placeMapView.convert(tapLocation, toCoordinateFrom: placeMapView)
        GeoLocation(coordinates.latitude, coordinates.longitude).request() { [weak self] in
            guard let this = self else { return }
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = $0.locality
            annotation.subtitle = $0.name
            this.placeMapView.addAnnotation(annotation)
        }
    }
    
    func kelvinToCelsius(_ temperature: Double) -> Double {
        return ((temperature - 273.15) * 1000) / 1000
    }
    
    func makeCopy(_ place: Place) {
        guard placeCopy == nil else { return }
        placeCopy = Place(place.getName(), place.getAddress(), place.getLatitude(), place.getLongitude())
    }
    
    @objc
    func cancelButtonPressed(_ sender: UIBarButtonItem) {
        cancel()
        delegate?.cancel()
    }
    
    func cancel() {
        guard let place = place, let placeCopy = placeCopy else { return }
        if placeCopy.getName() != "" {
            place.setName(placeCopy.getName())
            place.setAddress(placeCopy.getAddress())
            place.setLatitude(placeCopy.getLatitude())
            place.setLongitude(placeCopy.getLongitude())
            displayPlace()
        }
    }
}
