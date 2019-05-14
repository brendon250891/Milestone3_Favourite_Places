//
//  Weather.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

/// Used to decode the returned JSON from openweathermap.org
struct Weather: Codable, Equatable {
    /// Weather description information
    var weather: [WeatherDescription]
    
    /// Weather temperature information.
    var main: WeatherTemperature
    
    static func ==(lhs: Weather, rhs: Weather) -> Bool {
        return lhs.weather[0].description == rhs.weather[0].description && lhs.main.minTemperature == rhs.main.minTemperature && lhs.main.maxTemperature == rhs.main.maxTemperature
    }
}

/// Used to decode the JSON data contained within the weather object.
struct WeatherDescription: Codable {
    var description: String
    
    /// Gets the appropriate image name for weather descriptions.
    /// - Returns: The name of the image asset.
    func getImageString() -> String {
        switch description {
        case "broken clouds": return "brokenClouds"
        case "clear sky" : return "skyIsClear"
        case "few clouds": return "fewClouds"
        case "light rain" : return "lightRain"
        case "scattered cloud" : return "scatteredCloud"
        case "sky is clear" : return "skyIsClear"
        case "snow" : return "snow"
        default: return "brokenClouds"
        }
    }
}

/// Used to decode JSON data contained within the main object.
struct WeatherTemperature: Codable {
    /// The minimum temperature.
    var minTemperature: Double
    
    /// The maximum temperature.
    var maxTemperature: Double
    
    /// Maps struct variables to JSON keys that have different spelling.
    private enum CodingKeys: String, CodingKey {
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
    }
}
