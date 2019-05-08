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

class PlaceDetailViewController: UITableViewController, UITextFieldDelegate {
    var place: Place?
    var placeCopy: Place?
    weak var delegate: PhoneDelegate?

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
        print(getFormattedDate())
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
        splitViewController?.navigationItem.rightBarButtonItem = cancelButton
    }
    
    @IBAction func addressTextFieldFinishedEditing(_ sender: Any) {
        if placeLatitudeTextField.text == "" && placeLongitudeTextField.text == "" {
            guard let address = placeAddressTextField.text else { return }
            GeoLocation(address).request() { [weak self] in
                guard let location = $0.location else { return }
                self?.placeLatitudeTextField.text = "\(location.coordinate.latitude)"
                self?.placeLongitudeTextField.text = "\(location.coordinate.longitude)"
            }
        }
    }
    
    @IBAction func placeAddressTextFieldFinishedEditing(_ sender: Any) {
        if placeLatitudeTextField.text == "" && placeLongitudeTextField.text == "" {
            guard let address = placeAddressTextField.text else { return }
            let geoLookup = CLGeocoder()
            geoLookup.geocodeAddressString(address) { [weak self] in
                guard let placemarks = $0, let _ = $1 else { return }
                let placemark = placemarks[0]
                guard let location = placemark.location else { return }
                self?.placeLatitudeTextField.text = "\(location.coordinate.latitude)"
                self?.placeLongitudeTextField.text = "\(location.coordinate.longitude)"
            }
        }
    }
    @IBAction func placeLatitudeTextFieldFinishedEditing(_ sender: Any) {
        if canReverseGeoLookup() {
            reverseGeoLookup()
        }
    }
    
    @IBAction func placeLatitudeTextFieldChanged(_ sender: Any) {
        if !hasSunriseAndSunsetTimes() {
            requestSunriseAndSunsetTimes()
        }
        if !hasWeatherInformation() {
            requestWeatherInformation()
        }
    }
    
    @IBAction func placeLongitudeTextFieldFinishedEditing(_ sender: Any) {
        if canReverseGeoLookup() {
            reverseGeoLookup()
        }
    }
    
    @IBAction func placeLongitudeTextFieldChanged(_ sender: Any) {
        
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
    
    func requestSunriseAndSunsetTimes() {
        guard let latText = placeLatitudeTextField.text, let lonText = placeLongitudeTextField.text, let latitude = Double(latText), let longitude = Double(lonText) else { return }
        SunriseSunsetAPI(latitude, longitude, getFormattedDate()).request() { [weak self] in
            guard let sunriseAndSunsetTimes = $0, let this = self else { return }
            this.sunriseTimeLabel.text = sunriseAndSunsetTimes.sunrise
            this.middayTimeLabel.text = sunriseAndSunsetTimes.midday
            this.sunsetTimeLabel.text = sunriseAndSunsetTimes.sunset
            this.twilightTimeLabel.text = sunriseAndSunsetTimes.twilight
            guard let place = this.place else { return }
            place.addSunriseAndSunsetTimes(this.getFormattedDate(), sunriseAndSunset: sunriseAndSunsetTimes)
        }
    }
    
    func requestWeatherInformation() {
        guard let placeName = placeNameTextField.text else { return }
        WeatherAPI(placeName).request() { [weak self] in
            guard let this = self else { return }
            let weather = $0
            this.weatherDateLabel.text = this.datePicker.date == Date() ? "Today" : this.getFormattedDate()
            this.weatherTypeLabel.text = weather.weather.description
            this.lowTempLabel.text = weather.main.minTemperature
            this.highTempLabel.text = weather.main.maxTemperature
            guard let place = this.place else { return }
            place.addWeather(this.getFormattedDate(), weather: weather)
        }
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
            guard let name = $0.locality else { return }
            self?.placeAddressTextField.text = name
            self?.getWeatherInformation(name)
        }
        getSunriseAndSunsetTimes(latitude, longitude)
    }
    
    func getSunriseAndSunsetTimes(_ latitude: Double, _ longitude: Double) {
        SunriseSunsetAPI(latitude, longitude, getFormattedDate()).request() { [weak self] in
            guard let sunriseAndSunsetTimes = $0 else { return }
            self?.sunriseTimeLabel.text = sunriseAndSunsetTimes.sunrise
            self?.middayTimeLabel.text = sunriseAndSunsetTimes.midday
            self?.sunsetTimeLabel.text = sunriseAndSunsetTimes.sunset
            self?.twilightTimeLabel.text = sunriseAndSunsetTimes.twilight
        }
    }
    
    func getWeatherInformation(_ cityName: String) {
        WeatherAPI(cityName).request() { [weak self] in
            let weather = $0
            self?.weatherDateLabel.text = self?.datePicker.date == Date() ? "Today" : self?.getFormattedDate()
            self?.weatherTypeLabel.text = weather.weather.description
            self?.lowTempLabel.text = weather.main.minTemperature
            self?.highTempLabel.text = weather.main.maxTemperature
        }
    }
    
    func displayPlace() {
        guard let place = place else { return }
        placeNameTextField.text = place.getName()
        placeAddressTextField.text = place.getAddress()
        placeLatitudeTextField.text = place.getLatitude() == 0.0 ? "" : "\(place.getLatitude())"
        placeLongitudeTextField.text = place.getLongitude() == 0.0 ? "" : "\(place.getLongitude())"
        if hasApiInformation(place) {
            displaySunriseAndSunset(place)
            displayWeather(place)
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
        dayLengthLabel.text = sunriseAndSunset.dayLength
    }
    
    func displayWeather(_ place: Place) {
        let date = getFormattedDate()
        guard let weather = place.getWeather(date) else { return }
        lowTempLabel.text = weather.main.minTemperature
        highTempLabel.text = weather.main.maxTemperature
        weatherTypeLabel.text = weather.weather.description
        weatherTypeImage.image = UIImage(imageLiteralResourceName: weather.weather.description)
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
        
    }
}
