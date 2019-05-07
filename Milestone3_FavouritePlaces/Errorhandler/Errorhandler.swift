//
//  Errorhandler.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 7/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

extension String: Error {}

struct UserInput {
    var contentType: String
    var field: String
    var value: String
}

class Errorhandler {
    var userInput: [UserInput]
    
    init(_ userInput: [UserInput]) {
        self.userInput = userInput
    }
    
    func validateUserInput() throws {
        for input in userInput {
            do {
                if input.contentType == "location" {
                    try validateLocation(input)
                } else {
                    try validateData(input)
                }
            } catch {
                throw "\(error)"
            }
        }
    }
    
    private func validateData(_ input: UserInput) throws {
        do {
            try isValueEmpty(input.field, input.value)
            try isNotNumeric(input.field, input.value)
        } catch {
            throw "\(error)"
        }
    }
    
    private func validateLocation(_ input: UserInput) throws {
        do {
            try isValueEmpty(input.field, input.value)
            try isNumeric(input.field, input.value)
        } catch {
            throw "\(error)"
        }
    }
    
    private func isValueEmpty(_ field: String, _ value: String) throws {
        if value == "" {
            throw "\(field) must not be empty!"
        }
    }
    
    private func isNotNumeric(_ field: String, _ value: String) throws {
        if Int(value) != nil {
            throw "\(field) must not be numeric!"
        }
    }
    
    private func isNumeric(_ field: String, _ value: String) throws {
        if Double(value) == nil {
            throw "\(value) is not a valid \(field)"
        }
    }
}
