//
//  SunriseAndSunset.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

struct SunriseAndSunsetResponse: Codable {
    var results: SunriseAndSunset
    var status: String
}

struct SunriseAndSunset: Codable {
    /// The sunrise time.
    var sunrise: String
    
    /// The sunset time.
    var sunset: String
    
    /// The length of the day.
    var dayLength: String
    
    /// The midday time
    var midday: String
    
    /// The twilight time.
    var twilight: String
    
    private enum CodingKeys: String, CodingKey {
        case sunrise
        case sunset
        case midday = "solar_noon"
        case twilight = "civil_twilight_end"
        case dayLength = "day_length"
    }
}
