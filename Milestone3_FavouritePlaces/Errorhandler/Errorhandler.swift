//
//  Errorhandler.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 7/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import Foundation

/// Extend string to handle Error types.
extension String: Error {}

/// Contains the expected user input information
struct UserInput {
    /// The content type that the text field expects.
    var contentType: String
    
    /// The name of the text field (user friendly).
    var field: String
    
    /// The value to be checked.
    var value: String
}

/// Handles the checking of user input information for errors.
class Errorhandler {
    /// The user inputs that are to be checked.
    var userInput: [UserInput]
    
    /// Default Constructor.
    init(_ userInput: [UserInput]) {
        self.userInput = userInput
    }
    
    /// Validates any user input queued to be checked.
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
    
    /// Validates any data that isn't a location.
    /// - Parameters:
    ///     - input: The input to be checked.
    /// - Throws: Error message if the input contains errors.
    private func validateData(_ input: UserInput) throws {
        do {
            try isValueEmpty(input.field, input.value)
            try isNotNumeric(input.field, input.value)
        } catch {
            throw "\(error)"
        }
    }
    
    /// Validates location inputs.
    /// - Parameters:
    ///     - input: The user input to be checked.
    /// - Throws: Error message if input contains errors.
    private func validateLocation(_ input: UserInput) throws {
        do {
            try isValueEmpty(input.field, input.value)
            try isNumeric(input.field, input.value)
        } catch {
            throw "\(error)"
        }
    }
    
    /// Checks for empty values.
    /// - Parameters:
    ///     - field: The name of the input field.
    ///     - value: The value to be checked.
    /// - Throws: Error message if the value is empty.
    private func isValueEmpty(_ field: String, _ value: String) throws {
        if value == "" {
            throw "\(field) must not be empty!"
        }
    }
    
    /// Checks if the value is not numeric.
    /// - Parameters:
    ///     - field: The name of the input field.
    ///     - value: the value to be checked.
    /// - Throws: Error message if the value is numeric
    private func isNotNumeric(_ field: String, _ value: String) throws {
        if Int(value) != nil {
            throw "\(field) must not be numeric!"
        }
    }
    
    /// Checks if the balue is numeric
    /// - Parameters:
    ///     - field: The name of the input field.
    ///     - value: The value to be checked.
    private func isNumeric(_ field: String, _ value: String) throws {
        if Double(value) == nil {
            throw "\(value) is not a valid \(field)"
        }
    }
}
