//
//  StandardPhoneDelegate.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 4/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

/// Protocols needed for regular phone use.
protocol PhoneDelegate: class {
    /// Handles saving of data when returning back to master view.
    func save()
    
    /// Handles cancelling of either adding or updating of Categories or Places.
    func cancel()
}
