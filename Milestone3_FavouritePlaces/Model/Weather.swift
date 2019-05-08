//
//  Weather.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

struct Weather: Codable {
    var weather: WeatherDescription
    var main: WeatherTemperature
}

struct WeatherDescription: Codable {
    var description: String
}

struct WeatherTemperature: Codable {
    /// The minimum temperature.
    var minTemperature: String
    
    /// The maximum temperature.
    var maxTemperature: String
    
    private enum CodingKeys: String, CodingKey {
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
    }
}
