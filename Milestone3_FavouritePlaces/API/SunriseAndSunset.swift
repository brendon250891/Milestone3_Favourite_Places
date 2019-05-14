//
//  SunriseAndSunset.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

/// Used to decode the JSON response of calls to sunrise-sunset API.
struct SunriseAndSunsetResponse: Codable {
    /// The decoded results.
    var results: SunriseAndSunset
    
    /// the decoded status.
    var status: String
}

/// Used to decode the JSON data in the results.
struct SunriseAndSunset: Codable, Equatable {
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
    
    /// Maps struct variables to JSON keys that have different spelling.
    private enum CodingKeys: String, CodingKey {
        case sunrise
        case sunset
        case midday = "solar_noon"
        case twilight = "civil_twilight_end"
        case dayLength = "day_length"
    }
    
    static func ==(lhs: SunriseAndSunset, rhs: SunriseAndSunset) -> Bool {
        return lhs.sunrise == rhs.sunrise && lhs.sunset == rhs.sunset && lhs.midday == rhs.midday && lhs.twilight == rhs.twilight && lhs.dayLength == rhs.dayLength
    }
}
