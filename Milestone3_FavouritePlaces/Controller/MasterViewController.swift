//
//  MasterViewController.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    /// The default detail view to be displayed next to the master view when in split view.
    var categoryDetailViewController: CategoryDetailViewController? = nil
    
    /// The data to be used to be displayed in the table.
    var categories = CategoryDB()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            categoryDetailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? CategoryDetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.getCategoryCount()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.getCategory(section).getPlaceCount() + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
        if indexPath.row == categories.getCategory(indexPath.section).getPlaceCount() {
            cell.textLabel?.text = "+ Add Place"
            cell.detailTextLabel?.text = ""
        } else {
            let place = categories.getCategory(indexPath.section).getPlace(indexPath.row)
            cell.textLabel?.text = place.getName()
            cell.detailTextLabel?.text = place.getAddress()
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == categories.getCategory(indexPath.section).getPlaceCount() ? false : true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

