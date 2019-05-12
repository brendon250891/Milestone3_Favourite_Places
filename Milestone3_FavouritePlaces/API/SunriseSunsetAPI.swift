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
    
    func getApiURL() -> URL? {
        guard let apiURL = URL(string: "https://api.sunrise-sunset.org/json?lat=\(latitude)&lng=\(longitude)&date=\(date)") else { return nil }
        return apiURL
    }
    
    func testRequest(completion: (SunriseAndSunset?) -> ()) {
        let sunriseAndSunset = SunriseAndSunsetResponse(results: SunriseAndSunset(sunrise: "8:00:00 PM", sunset: "8:00:00 AM", dayLength: "12:00:00", midday: "2:00:00 PM", twilight: "8:30:00 PM"), status: "OK")
        completion(sunriseAndSunset.results)
    }
}
