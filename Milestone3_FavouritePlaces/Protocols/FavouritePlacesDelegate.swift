//
//  StandardPhoneDelegate.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 4/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

/// Protocols needed for regular phone use.
protocol FavouritePlacesDelegate: class {
    /// Handles saving of data when returning back to master view.
    func save()
    
    /// Handles cancelling of either adding or updating of Categories or Places when not in split view.
    //func cancel()
    
    /// Handles the deletion of Categories and Places
    /// - Parameters:
    ///     - object: The object to delete.
    func delete<T>(_ object: T)
    
    /// Handles the dismissing of modal views.
    func dismiss()
}
