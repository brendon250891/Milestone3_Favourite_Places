//
//  PlaceDelegate.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 13/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

protocol PlaceDelegate: class {
    func save()
    func cancel()
    func delete<T>(_ object: T)
}
