//
//  CategoryDB.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

class CategoryDB {
    /// The file path where the saved data is located.
    private let filePath: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("data").appendingPathExtension("json")
    
    /// The data for the application.
    private var categories: [Category]
    
    /// Default Constructor.
    init() {
        categories = [Category]()
        if fileExists() && isSavedData() {
            setSavedData()
        }
    }
    
    /// Gets the number of Categories currently stored.
    /// - Returns: The nunmber of Categories.
    func getCategoryCount() -> Int {
        return self.categories.count
    }
    
    /// Gets the Category given it's index.
    /// - Returns: The Category at the given index.
    func getCategory(_ index: Int) -> Category {
        return categories[index]
    }
    
    func fileExists() -> Bool {
        return FileManager.default.fileExists(atPath: "\(filePath)")
    }
    /// Checks if there is already stored data.
    /// - Returns: true if there is data, false otherwise.
    func isSavedData() -> Bool {
        var found = false
        do {
            let data = try Data(contentsOf: filePath)
            found = data.isEmpty ? false : true
        } catch {
            print("Error: \(error)")
            found = false
        }
        return found
    }
    
    /// Sets the Category data to the stored data.
    func setSavedData(){
        do {
            let data = try Data(contentsOf: filePath)
            categories = try JSONDecoder().decode([Category].self, from: data)
        } catch {
            print("Error: \(error)")
        }
    }
}
