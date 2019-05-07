//
//  DetailViewController.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import UIKit

class CategoryDetailViewController: UITableViewController, UITextFieldDelegate {
    var category: Category?
    var categoryCopy: Category?
    weak var delegate: PhoneDelegate?

    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var dateCreatedTextField: UITextField!
    @IBOutlet weak var placeCountTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCancelButton()
        displayCategory()
        setupTextFields()
    }
    
    @IBAction func categoryNameTextFieldFinishedEditing(_ sender: Any) {
        if isInSplitView() && isValidUserInput(categoryNameTextField) {
            save()
            delegate?.save()
            clearTextFields()
        }
    }
    
    func setupCancelButton() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
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
    
    func makeCopy(_ category: Category) {
        guard categoryCopy == nil else { return }
        categoryCopy = Category(category.getCategoryName())
    }
    
    func setupTextFields() {
        categoryNameTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func clearTextFields() {
        let textFields = getTextFields()
        for textField in textFields {
            textField.text = ""
        }
    }
    
    func getTextFields() -> [UITextField] {
        return [categoryNameTextField, dateCreatedTextField, placeCountTextField]
    }
    
    @objc
    func cancelButtonPressed() {
        cancel()
        delegate?.cancel()
    }
    
    func save() {
        guard let category = category, let categoryName = categoryNameTextField.text else { return }
        category.setCategoryName(categoryName)
    }
    
    func cancel() {
        guard let categoryCopy = categoryCopy, let category = category else { return }
        category.setCategoryName(categoryCopy.getCategoryName())
        self.category = nil
        self.categoryCopy = nil
        displayCategory()
    }
    
    func isInSplitView() -> Bool {
        guard let isCollapsed = splitViewController?.isCollapsed else { return false }
        return !isCollapsed
    }
    
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

