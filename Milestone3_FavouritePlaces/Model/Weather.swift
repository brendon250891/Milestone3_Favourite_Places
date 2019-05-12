//
//  Weather.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

struct Weather: Codable {
    var weather: [WeatherDescription]
    var main: WeatherTemperature
}

struct WeatherDescription: Codable {
    var description: String
    
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
        return ""
    }
}

struct WeatherTemperature: Codable {
    /// The minimum temperature.
    var minTemperature: Double
    
    /// The maximum temperature.
    var maxTemperature: Double
    
    private enum CodingKeys: String, CodingKey {
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
    }
}
