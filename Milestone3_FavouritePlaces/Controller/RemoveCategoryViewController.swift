//
//  RemoveCategoryViewController.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 7/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import UIKit

class RemoveCategoryViewController: UIViewController {
    var category: Category?
    weak var delegate: RemoveCategoryDelegate?

    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let category = category else  { return }
        messageLabel.text?.append(category.getCategoryName())
    }
    
    @IBAction func removeCategoryButtonPressed(_ sender: Any) {
        guard let category = category else { return }
        delegate?.remove(category)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        delegate?.dismiss()
    }
}
