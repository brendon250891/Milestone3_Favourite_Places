//
//  GeoLocation.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 8/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation
import CoreLocation

class GeoLocation {
    var latitude: Double?
    var longitude: Double?
    var placeName: String?
    
    init(_ placeName: String) {
        self.placeName = placeName
        self.latitude = nil
        self.longitude = nil
    }
    
    init(_ latitude: Double, _ longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.placeName = nil
    }
    
    func request(completion: @escaping (CLPlacemark) -> ()) {
        guard let placeName = placeName else {
            guard let latitude = latitude, let longitude = longitude else { return }
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) {
                guard let placemarks = $0 else {
                    let _ = $1
                    return
                }
                completion(placemarks[0])
            }
            return
        }
        CLGeocoder().geocodeAddressString(placeName) {
            guard let placemarks = $0 else {
                let _ = $1
                return
            }
            completion(placemarks[0])
        }
    }
}
