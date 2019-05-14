//
//  WeatherAPI.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

/// Class that handles API calls to openweathermap.org
class WeatherAPI {
    /// API key to use to validate API calls to openweathermap.org.
    let apiKey = "afa7fa6fcb6cd2110cca0b4bff89c4ea"
    
    /// The city name to request information for.
    var cityName: String
    
    /// Default Constructor
    /// - Parameters:
    ///     - cityName: The city name to request information for.
    init(_ cityName: String) {
        self.cityName = cityName
        if self.cityName.contains(" ") {
            self.cityName = cityName.replacingOccurrences(of: " ", with: "+")
        }
    }
    
    /// Handles the request of information from openweathermap.org API.
    /// - Parameters:
    ///     - completion: How the returned data should be handled.
    func request(completion: @escaping (Weather) -> ()) {
        guard let apiURL = getApiURL() else { return }
        URLSession(configuration: .default).dataTask(with: apiURL) {
            guard let data = $0 else {
                print("Weather API Call Error: \(String(describing: $2))")
                return
            }
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                completion(weather)
            } catch {
                print("Weather Request Error: \(error)")
            }
        }.resume()
    }
    
    /// Generates the URL to call for the data.
    func getApiURL() -> URL? {
        guard let apiURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName),AU&APPID=\(apiKey)") else { return nil }
        return apiURL
    }
}


