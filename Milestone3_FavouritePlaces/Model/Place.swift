//
//  Place.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

class Place: Codable, Equatable {
    /// The name of the Place.
    private var name: String
    
    /// The address of the Place.
    private var address: String
    
    /// The latitude of the Place.
    private var latitude: Double
    
    /// The longitude of the Place.
    private var longitude: Double
    
    /// Stores sunrise and sunset times if it has been looked up previously.
    private var sunriseSunsetTimes: [String: SunriseAndSunset]
    
    /// Stores the weather information if it has been requested previously.
    private var weather: [String: Weather]
    
    /// Default Constructor.
    init() {
        self.name = ""
        self.address = ""
        self.latitude = 0
        self.longitude = 0
        self.sunriseSunsetTimes = [String: SunriseAndSunset]()
        self.weather = [String: Weather]()
    }
    
    /// Constructor with parameters.
    /// - Parameters:
    ///     - name: The name of the Place.
    ///     - address: The address of the Place.
    ///     - latitude: The latitude of the Place.
    ///     - longitude: The longitude of the Place.
    init(_ name: String, _ address: String, _ latitude: Double, _ longitude: Double) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.sunriseSunsetTimes = [String: SunriseAndSunset]()
        self.weather = [String: Weather]()
    }
    
    /// Gets the name of the Place.
    /// - Returns: The Place's name.
    func getName() -> String {
        return self.name
    }
    
    /// Sets the name of the Place.
    /// - Parameters:
    ///     - name: The name to set.
    func setName(_ name: String) {
        self.name = name
    }
    
    /// Gets the address of the Place.
    /// - Returns: The Place's address.
    func getAddress() -> String {
        return self.address
    }
    
    /// Sets the address of the Place.
    /// - Parameters:
    ///      - address: The address to set.
    func setAddress(_ address: String) {
        self.address = address
    }
    
    /// Gets the latitude of the Place.
    /// - Returns: The Place's latitude.
    func getLatitude() -> Double {
        return self.latitude
    }
    
    /// Sets the latitude of the Place.
    /// - Parameters:
    ///     - latitude: The latitude to set.
    func setLatitude(_ latitude: Double) {
        self.latitude = latitude
    }
    
    /// Gets the longitude of the Place.
    /// - Returns: The Place's longitude.
    func getLongitude() -> Double {
        return self.longitude
    }
    
    /// Sets the longitude of the Place.
    /// - Parameters:
    ///     - longitude: The longitude to set.
    func setLongitude(_ longitude: Double) {
        self.longitude = longitude
    }
    
    /// Gets the sunrise and sunsets data for a date if it has been previously requested.
    /// - Parameters:
    ///     - date: The date to retrieve the data for if it exists.
    /// - Returns: Sunrise and sunset object if found, otherwise nil.
    func getSunriseAndSunsetTimes(_ date: String) -> SunriseAndSunset? {
        if sunriseSunsetTimes.count == 0 || sunriseSunsetTimes[date] == nil {
            return nil
        }
        return sunriseSunsetTimes[date]
    }
    
    /// Adds the sunrise and sunset data for a particular date.
    /// - Parameters:
    ///     - date: The date to associate with the data.
    ///     - sunriseAndSunset: the sunrise and sunset data for the given date.
    func addSunriseAndSunsetTimes(_ date: String, sunriseAndSunset: SunriseAndSunset) {
        self.sunriseSunsetTimes[date] = sunriseAndSunset
    }
    
    /// Gets the weather data for a date if it has been previously requested.
    /// - Parameters:
    ///     - date: The date to retrieve the data for if it exists.
    /// - Returns: Weather object if found, otherwise nil.
    func getWeather(_ date: String) -> Weather? {
        if weather.count == 0 || weather[date] == nil {
            return nil
        }
        return weather[date]
    }
    
    /// Adds the weather data for a particular date.
    /// - Parameters:
    ///     - date: The date to associate the data with.
    ///     - weather: The weather data for the given date.
    func addWeather(_ date: String, weather: Weather) {
        self.weather[date] = weather
    }
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.getName() == rhs.getName() && lhs.getAddress() == rhs.getAddress() && lhs.getLatitude() == rhs.getLatitude() && lhs.getLongitude() == rhs.getLongitude()
    }
}
