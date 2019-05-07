//
//  RemoveCategoryDelegate.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 7/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

protocol RemoveCategoryDelegate: class {
    func remove(_ category: Category)
    func dismiss()
}
