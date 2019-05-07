//
//  PlaceDetailViewController.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 7/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import UIKit
import MapKit

class PlaceDetailViewController: UITableViewController, UITextFieldDelegate {
    var place: Place?
    var placeCopy: Place?

    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placeAddressTextField: UITextField!
    @IBOutlet weak var placeLatitudeTextField: UITextField!
    @IBOutlet weak var placeLongitudeTextField: UITextField!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
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
        dateFormatter.dateFormat = "dd-MM-YYYY"
        return dateFormatter.string(from: datePicker.date)
    }
    
    func displaySunriseAndSunset(_ place: Place) {
        let date = getFormattedDate()
        guard let sunriseAndSunset = place.getSunriseAndSunsetTimes(date) else { return }
        sunriseTimeLabel.text = sunriseAndSunset.sunrise
        sunsetTimeLabel.text = sunriseAndSunset.sunset
        dayLengthLabel.text = sunriseAndSunset.dayLength
    }
    
    func displayWeather(_ place: Place) {
        let date = getFormattedDate()
        guard let weather = place.getWeather(date) else { return }
        lowTempLabel.text = weather.minTemperature
        highTempLabel.text = weather.maxTemperature
        weatherTypeLabel.text = weather.forecast
        weatherTypeImage.image = UIImage(imageLiteralResourceName: "sunrise")
    }
    
    func makeCopy(_ place: Place) {
        guard placeCopy == nil else { return }
        placeCopy = Place(place.getName(), place.getAddress(), place.getLatitude(), place.getLongitude())
    }
}
