//
//  Category.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

class Category: Codable, Equatable {
    
    /// The name of the Category.
    private var categoryName: String
    
    private var dateCreated: Date
    
    /// The Places associated with the Category.
    private var places: [Place]
    
    private var isCollapsed: Bool = false
    
    /// Default constructor.
    init() {
        self.categoryName = ""
        self.dateCreated = Date()
        self.places = [Place]()
    }
    
    /// Constructor given a name parameter.
    /// - Parameters:
    ///     - name: The name of the Category.
    init(_ name: String) {
        self.categoryName = name
        self.dateCreated = Date()
        self.places = [Place]()
    }
    
    /// Gets the name of the Category.
    /// - Returns: The name of the Category.
    func getCategoryName() -> String {
        return self.categoryName
    }
    
    /// Sets the Category name.
    /// - Parameters:
    ///     - categoryName: The name of the Category.
    func setCategoryName(_ categoryName: String) {
        self.categoryName = categoryName
    }
    
    /// Gets the date that the Category was created.
    func getDateCreated() -> String {
        let dateFormatted = DateFormatter()
        dateFormatted.timeZone = TimeZone(secondsFromGMT: 3600 * 10)
        dateFormatted.dateStyle = .long
        dateFormatted.timeStyle = .medium
        return dateFormatted.string(from: self.dateCreated)
    }
    
    /// Gets the number of Places currently stored.
    /// - Returns: The number of Places.
    func getPlaceCount() -> Int {
        return places.count
    }
    
    /// Checks if the Category is collapsed or not.
    /// - Returns: true if collapsed, false otherwise.
    func isCategoryCollapsed() -> Bool {
        return self.isCollapsed
    }
    
    /// Collapses categories.
    func collapseCategory() {
        self.isCollapsed = !self.isCollapsed
    }
    
    /// Adds a Place object to the collection.
    func addPlace() {
        places.append(Place())
    }
    
    /// Gets the Place object given it's index.
    /// - Returns: The Place at the given index.
    func getPlace(_ index: Int) -> Place {
        return places[index]
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.getCategoryName() == rhs.getCategoryName() && lhs.getDateCreated() == rhs.getDateCreated() && lhs.getPlaceCount() == rhs.getPlaceCount()
    }
}
