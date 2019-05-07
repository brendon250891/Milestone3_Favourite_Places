//
//  TapGestureRecognizer.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 4/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import UIKit

class TapGestureRecognizer: UITapGestureRecognizer {
    var categoryIndex: Int
    
    init(target: Any?, action: Selector?, categoryIndex: Int) {
        self.categoryIndex = categoryIndex
        super.init(target: target, action: action)
    }
}
