//
//  PressGestureRecognizer.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 4/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import UIKit

/// Subclass of the UILongPressGestueRecognizer that adds an associated Category index.
class PressGestureRecognizer: UILongPressGestureRecognizer {
    /// The index of the Category.
    var categoryIndex: Int
    
    /// Default Constructor.
    /// - Parameters:
    ///     - target: The object to attach the PressGestureRecognizer to.
    ///     - action: The function to execute when gesture is activated.
    ///     - categoryIndex: The index of the Category.
    init(target: Any?, action: Selector?, categoryIndex: Int) {
        self.categoryIndex = categoryIndex
        super.init(target: target, action: action)
    }
}
