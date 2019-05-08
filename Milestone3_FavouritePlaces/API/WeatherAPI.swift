//
//  WeatherAPI.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

class WeatherAPI {
    var cityName: String
    
    init(_ cityName: String) {
        self.cityName = cityName
    }
    
    func request(completion: @escaping (Weather) -> ()) {
        guard let apiURL = getApiURL() else { return }
        URLSession(configuration: .default).dataTask(with: apiURL) {
            guard let data = $0, let _ = $1, let _ = $2 else {
                print("Weather API Call Error!")
                return }
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                completion(weather)
            } catch {
                print("Weather Request Error: \(error)")
            }
        }.resume()
    }
    
    func getApiURL() -> URL? {
        guard let apiURL = URL(string: "api.openweathermap.org/data/2.5/weather?q=\(cityName)") else { return nil }
        return apiURL
    }
}
