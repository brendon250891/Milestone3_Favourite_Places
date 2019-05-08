//
//  SunriseSunsetAPI.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

class SunriseSunsetAPI {
    var latitude: Double
    var longitude: Double
    var date: String
    
    init(_ latitude: Double, _ longitude: Double, _ date: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
    }
    
    func request(completion: @escaping (SunriseAndSunset?) -> ()) {
        guard let apiURL = getApiURL() else { return }
        URLSession(configuration: .default).dataTask(with: apiURL) {
            guard let data = $0, let _ = $1, let _ = $2 else {
                print("Sunrise and Sunset API Call Error!")
                return }
            do {
                let sunriseAndSunsetResponse = try JSONDecoder().decode(SunriseAndSunsetResponse.self, from: data)
                completion(sunriseAndSunsetResponse.results)
            } catch {
                print("Error: \(error)")
            }
        }.resume()
    }
    
    func getApiURL() -> URL? {
        guard let apiURL = URL(string: "https://api.sunrise-sunset.org/json?lat=\(latitude)&lng=\(longitude)&date=\(date)") else { return nil }
        return apiURL
    }
}
