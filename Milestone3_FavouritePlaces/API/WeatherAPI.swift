//
//  WeatherAPI.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

class WeatherAPI {
    let apiKey = "afa7fa6fcb6cd2110cca0b4bff89c4ea"
    var cityName: String
    
    init(_ cityName: String) {
        self.cityName = cityName
        if self.cityName.contains(" ") {
            self.cityName = cityName.replacingOccurrences(of: " ", with: "+")
        }
    }
    
    func request(completion: @escaping (Weather) -> ()) {
        guard let apiURL = getApiURL() else { return }
        URLSession(configuration: .default).dataTask(with: apiURL) {
            guard let data = $0 else {
                print("Weather API Call Error: \(String(describing: $2))")
                return }
            print(data)
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                completion(weather)
            } catch {
                print("Weather Request Error: \(error)")
            }
        }.resume()
    }
    
    func getApiURL() -> URL? {
        guard let apiURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName),AU&APPID=\(apiKey)") else { return nil }
        return apiURL
    }
    
    func testRequest(completion: @escaping (Weather) -> ()) {
        let weather = Weather(weather: [WeatherDescription(description: "broken clouds")], main: WeatherTemperature(minTemperature: 279.15, maxTemperature: 289.15))
        completion(weather)
    }
}
