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
        if !fileExists() {
            addCategory("Default")
            saveData()
        } else if isSavedData() {
            setSavedData()
        }
    }
    
    /// Adds a Category to the stored Categories.
    /// - Parameters:
    ///     - categoryName: Optional category name for the Category.
    func addCategory(_ categoryName: String? = nil) {
        guard let categoryName = categoryName else {
            categories.append(Category())
            return
        }
        categories.append(Category(categoryName))
    }
    
    /// Removes a Category object from the stored Categories.
    /// - Parameters:
    ///     - index: The index of the Category to remove.
    func removeCategory(_ index: Int) {
        categories.remove(at: index)
    }
    
    /// Removes a Category object from the stored Categories.
    /// - Parameters:
    ///     - category: The Category object to remove.
    /// - Returns: The index of the removed Category.
    func removeCategory(_ category: Category) -> Int? {
        for i in 0..<getCategoryCount() {
            if categories[i] == category {
                categories.remove(at: i)
                return i
            }
        }
        return nil
    }
    
    /// Searches for empty an empty Place in the Categories.
    /// - Returns: The index of the Category if one contains an empty Place.
    func findEmptyPlace() -> Int? {
        for categoryIndex in 0..<getCategoryCount() {
            for placeIndex in 0..<getCategory(categoryIndex).getPlaceCount() {
                if getCategory(categoryIndex).getPlace(placeIndex).getName() == "" {
                    return categoryIndex
                }
            }
        }
        return nil
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
    
    /// Checks if the file containing saved data exists.
    func fileExists() -> Bool {
        return FileManager.default.fileExists(atPath: filePath.path)
    }
    
    /// Saves data to the filepath
    func saveData() {
        do {
            let data = try JSONEncoder().encode(categories)
            try data.write(to: filePath, options: .atomic)
        } catch {
            print("Saving Error: \(error)")
        }
    }
    
    /// Checks if there is already stored data.
    /// - Returns: true if there is data, false otherwise.
    func isSavedData() -> Bool {
        var found = false
        do {
            let data = try Data(contentsOf: filePath)
            found = data.isEmpty ? false : true
        } catch {
            print("Checking for saved data Error: \(error)")
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
            print("Getting saved data Error: \(error)")
        }
    }
    
    /// Resets the saved data.
    func clearSavedData() {
        categories = [Category]()
        addCategory("Default")
        saveData()
        print("Data reset.")
    }
}
