//
//  TapGestureRecognizer.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 4/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import UIKit

/// Subclass of the UITapGestureRecognizer that adds an associated Category index.
class TapGestureRecognizer: UITapGestureRecognizer {
    /// The index of the Category.
    var categoryIndex: Int
    
    /// Default Constructor.
    /// - Parameters:
    ///     - target: The object to attach the TapGestureRecognizer to.
    ///     - action: The function to execute when gesture is activated.
    ///     - categoryIndex: The index of the Category.
    init(target: Any?, action: Selector?, categoryIndex: Int) {
        self.categoryIndex = categoryIndex
        super.init(target: target, action: action)
    }
}
