//
//  RemoveCategoryViewController.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 7/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import UIKit

class RemoveCategoryViewController: UIViewController {
    /// The Category passed from the master view.
    var category: Category?
    
    ///
    weak var delegate: FavouritePlacesDelegate?

    /// The label to display messages.
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let category = category else  { return }
        messageLabel.text?.append(category.getCategoryName())
    }
    
    /// Removes the Category if the remove button is pressed.
    @IBAction func removeCategoryButtonPressed(_ sender: Any) {
        guard let category = category else { return }
        delegate?.delete(category)
    }
    
    /// Dismisses the modal view when the cancel button is pressed.
    @IBAction func cancelButtonPressed(_ sender: Any) {
        delegate?.dismiss()
    }
}
