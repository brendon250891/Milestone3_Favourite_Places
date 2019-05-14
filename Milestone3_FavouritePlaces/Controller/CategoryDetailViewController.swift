//
//  DetailViewController.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import UIKit

class CategoryDetailViewController: UITableViewController, UITextFieldDelegate {
    /// The Category passed from the master view.
    var category: Category?
    
    /// A copy of the Category passed from the master view.
    var categoryCopy: Category?
    
    ///
    weak var delegate: FavouritePlacesDelegate?

    /// Category name text field.
    @IBOutlet weak var categoryNameTextField: UITextField!
    
    /// Date created text field.
    @IBOutlet weak var dateCreatedTextField: UITextField!
    
    /// Place count text field.
    @IBOutlet weak var placeCountTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCancelButton()
        displayCategory()
        setupTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !isInSplitView() {
            save()
            delegate?.save()
        }
    }
    
    /// Handles when the category name text field has lost focus.
    @IBAction func categoryNameTextFieldFinishedEditing(_ sender: Any) {
        if isInSplitView() && isValidUserInput(categoryNameTextField) {
            save()
            delegate?.save()
            clearTextFields()
        }
    }
    
    /// Sets up the cancel button.
    func setupCancelButton() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    /// Displays the Category information
    func displayCategory() {
        guard let category = category else {
            categoryNameTextField.isEnabled = false
            return
        }
        categoryNameTextField.text = category.getCategoryName()
        dateCreatedTextField.text = category.getDateCreated()
        placeCountTextField.text = "\(category.getPlaceCount())"
        makeCopy(category)
    }
    
    /// Makes a copy of the Category object
    /// - Parameters:
    ///     - category: The Category to make a copy of.
    func makeCopy(_ category: Category) {
        guard categoryCopy == nil else { return }
        categoryCopy = Category(category.getCategoryName())
    }
    
    /// Does initial text field setup.
    func setupTextFields() {
        categoryNameTextField.delegate = self
    }
    
    /// Asks the delegate if the text field should return.
    /// - Parameters:
    ///     - textField: The text field being edited.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// Clears all text fields.
    func clearTextFields() {
        let textFields = getTextFields()
        for textField in textFields {
            textField.text = ""
        }
    }
    
    /// Gets the textfields that are used.
    /// - Returns: An array of textfields.
    func getTextFields() -> [UITextField] {
        return [categoryNameTextField, dateCreatedTextField, placeCountTextField]
    }
    
    /// Handles the cancel button being pressed.
    @objc
    func cancelButtonPressed() {
        cancel()
    }
    
    /// Saves any changes made to the Category.
    func save() {
        guard let category = category, let categoryName = categoryNameTextField.text else { return }
        category.setCategoryName(categoryName)
    }
    
    /// If the Category was previously empty, it is deleted, otherwise it's reverted back to its state
    /// prior to changes that were made.
    func cancel() {
        guard let categoryCopy = categoryCopy, let category = category else { return }
        if categoryCopy.getCategoryName() == "" {
            delegate?.delete(category)
        } else {
            category.setCategoryName(categoryCopy.getCategoryName())
            delegate?.save()
        }
        self.category = nil
        self.categoryCopy = nil
        displayCategory()
    }
    
    /// Checks if the display is split view.
    /// - Returns: True if the display is in split view.
    func isInSplitView() -> Bool {
        guard let isCollapsed = splitViewController?.isCollapsed else { return false }
        return !isCollapsed
    }
    
    /// Validates the user input.
    /// - Parameters:
    ///     - textField: The text field to validate.
    /// - Returns: true if user input is valid.
    func isValidUserInput(_ textField: UITextField) -> Bool {
        guard let contentType = textField.textContentType, let value = textField.text, let field = textField.accessibilityIdentifier else { return false }
        let userInput = UserInput(contentType: contentType.rawValue, field: field, value: value)
        let errorhandler = Errorhandler([userInput])
        do {
            try errorhandler.validateUserInput()
            return true
        } catch {
            print("Error: \(error)")
        }
        return false
    }
    
}

