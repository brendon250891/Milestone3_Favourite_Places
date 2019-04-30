//
//  Category.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

class Category: Codable {
    /// The name of the Category.
    var name: String
    
    /// The Places associated with the Category.
    var places: [Place]
    
    init() {
        self.name = ""
        self.places = [Place]()
    }
    
    /// Gets the number of Places currently stored.
    /// - Returns: The number of Places.
    func getPlaceCount() -> Int {
        return places.count
    }
    
    /// Gets the Place object given it's index.
    /// - Returns: The Place at the given index.
    func getPlace(_ index: Int) -> Place {
        return places[index]
    }
}
