//
//  SunriseSunsetAPI.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

/// Class that handles API calls to sunrise-sunset.org
class SunriseSunsetAPI {
    /// The latitude of the location to retrieve information.
    var latitude: Double
    
    /// The longitude of the location to retrieve information.
    var longitude: Double
    
    /// The date to get information for.
    var date: String
    
    /// Default Constructor
    /// - Parameters:
    ///     - latitude: The latitude of the location.
    ///     - longitude: The longitude of the location.
    ///     - date: The date to retrieve for.
    init(_ latitude: Double, _ longitude: Double, _ date: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
    }
    
    /// Handles the request of information from the sunrise-sunset API.
    /// - Parameters:
    ///     - completion: How the returned data should be handled.
    func request(completion: @escaping (SunriseAndSunset?) -> ()) {
        guard let apiURL = getApiURL() else { return }
        URLSession(configuration: .default).dataTask(with: apiURL) {
            guard let data = $0 else {
                print("Sunrise and Sunset API Call Error: \(String(describing: $2))")
                return
            }
            do {
                let sunriseAndSunsetResponse = try JSONDecoder().decode(SunriseAndSunsetResponse.self, from: data)
                completion(sunriseAndSunsetResponse.results)
            } catch {
                print("Error: \(error)")
            }
        }.resume()
    }
    
    /// Generates the URL to call for the data.
    func getApiURL() -> URL? {
        guard let apiURL = URL(string: "https://api.sunrise-sunset.org/json?lat=\(latitude)&lng=\(longitude)&date=\(date)") else { return nil }
        return apiURL
    }
}
