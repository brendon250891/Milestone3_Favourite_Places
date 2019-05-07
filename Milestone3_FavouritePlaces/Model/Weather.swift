//
//  Weather.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

struct Weather: Codable {
    /// The minimum temperature.
    var minTemperature: String
    
    /// The maximum temperature.
    var maxTemperature: String
    
    /// The forecast for the day.
    var forecast: String
    
    func getWeatherImage() -> String {
        switch forecast {
        case "rain":
            return "rainImagePath"
        default:
            return "Fine"
        }
    }
}
