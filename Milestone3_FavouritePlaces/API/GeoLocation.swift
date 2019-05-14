//
//  GeoLocation.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 8/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation
import CoreLocation

/// Class that handles location and reverse geolocation calls to the CLGeocoder API.
class GeoLocation {
    /// The latitude of the location.
    var latitude: Double?
    
    /// The longitude of the location.
    var longitude: Double?
    
    /// The name of the place.
    var placeName: String?
    
    /// Reverse Geolocation Constructor.
    /// - Parameters:
    ///     - placeName: The place name to get coordinates for.
    init(_ placeName: String) {
        self.placeName = placeName
        self.latitude = nil
        self.longitude = nil
    }
    
    /// Address location Constructor.
    /// - Parameters:
    ///     - latitude: The latitude of the location.
    ///     - longitude: The longitude of the location.
    init(_ latitude: Double, _ longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.placeName = nil
    }
    
    /// Handles the request of information from the CLGeocoder API.
    /// - Parameters:
    ///     - completion: How the returned data should be handled.
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
