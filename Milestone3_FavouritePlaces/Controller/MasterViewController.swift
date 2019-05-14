//
//  MasterViewController.swift
//  Milestone3_FavouritePlaces
//
//  Created by Brendon on 1/5/19.
//  Copyright © 2019 Brendon. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, FavouritePlacesDelegate {
    /// The default detail view to be displayed next to the master view when in split view.
    var categoryDetailViewController: CategoryDetailViewController? = nil
    
    /// The data to be used to be displayed in the table.
    var categories = CategoryDB()
    
    /// Flag indicating whether a Category is being added or not.
    var addingCategory = false
    
    /// Flag indicating whether a Place is being added or not.
    var addingPlace = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            categoryDetailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? CategoryDetailViewController
        }
        
        addButtonSetup()
        clearDataSetup()
    }
    
    /// Handles setup of the add button.
    func addButtonSetup() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    /// Handles setup of the clear data button.
    func clearDataSetup() {
        let clearDataButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearSavedData))
        navigationItem.rightBarButtonItems?.append(clearDataButton)
    }
    
    /// Adds a Category and segues to the Category Detail View.
    @objc
    func addButtonPressed(_ sender: UIBarButtonItem) {
        addingCategory = true
        categories.addCategory()
        performSegue(withIdentifier: "showCategoryDetailView", sender: sender)
    }
    
    /// Clears all saved data.
    @objc
    func clearSavedData(_ sender: UIBarButtonItem) {
        //categories.clearSavedData()
        //tableView.reloadData()
        categories.getCategory(0).addPlace()
        let place = categories.getCategory(0).getPlace(categories.getCategory(0).getPlaceCount() - 1)
        place.setName("Test")
        place.setAddress("Test")
        place.setLatitude(100)
        place.setLongitude(100)
        let indexPath = IndexPath(row: categories.getCategory(0).getPlaceCount() - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    /// Prepares views before seguing.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = setupControllersWithNavigationControllers(segue, sender) else { return }
        switch segue.identifier {
        case "showCategoryDetailView":
            setupShowCategoryDetailView(controller, sender)
        case "showRemoveCategoryModal":
            setupRemoveCategoryModalView(controller, sender)
        case "showPlaceDetailView":
            setupShowPlaceDetailView(controller, sender)
        default:
            break
        }
    }
    
    /// Sets up view controllers that have a navigation controller attached.
    /// - Parameters:
    ///     - segue: The segue that is being run.
    ///     - sender: The object that initiated the segue.
    /// - Returns:
    func setupControllersWithNavigationControllers(_ segue: UIStoryboardSegue, _ sender: Any?) -> UIViewController? {
        guard let controller = (segue.destination as? UINavigationController)?.topViewController else {
            if let controller = segue.destination as? RemoveCategoryViewController {
                return controller
            }
            return nil
        }
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
        return controller
    }
    
    /// Sets up the Category Detail View with all necesary data.
    /// - Parameters:
    ///     - controller: The view controller to setup.
    ///     - sender: The object that initiated the setup.
    func setupShowCategoryDetailView(_ controller: UIViewController, _ sender: Any?) {
        guard let categoryDetailViewController = controller as? CategoryDetailViewController else {
            print("Error: Controller cannot be cast as CategoryDetailViewController.")
            return
        }
        categoryDetailViewController.delegate = self
        var categoryIndex: Int? = nil
        var viewTitle: String? = nil
        if let gesture = sender as? TapGestureRecognizer {
            categoryIndex = gesture.categoryIndex
            viewTitle = "Edit Category"
        } else if sender as? UIBarButtonItem != nil {
            categoryIndex = categories.getCategoryCount() - 1
            viewTitle = "Add Category"
        }
        guard let index = categoryIndex, let title = viewTitle else { return }
        categoryDetailViewController.category = categories.getCategory(index)
        categoryDetailViewController.navigationItem.title = title
    }
    
    /// Sets up the Remove Category Modal View with necessary data.
    /// - Parameters:
    ///     - controller: The controller to setup.
    ///     - sender: The object that initiated the setup.
    func setupRemoveCategoryModalView(_ controller: UIViewController, _ sender: Any?) {
        guard let removeCategoryController = controller as? RemoveCategoryViewController, let gesture = sender as? PressGestureRecognizer else { return }
        removeCategoryController.delegate = self
        removeCategoryController.category = categories.getCategory(gesture.categoryIndex)
    }
    
    /// Sets up the Place Detail View with necessary data.
    /// - Parameters:
    ///     - controller: The view controller to setup.
    ///     - sender: The object that initiated setup.
    func setupShowPlaceDetailView(_ controller: UIViewController, _ sender: Any?) {
        guard let showPlaceDetailViewController = controller as? PlaceDetailViewController, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return }
        showPlaceDetailViewController.delegate = self
        let category = categories.getCategory(indexPath.section)
        if indexPath.row == category.getPlaceCount() {
            category.addPlace()
            showPlaceDetailViewController.place = category.getPlace(category.getPlaceCount() - 1)
            showPlaceDetailViewController.navigationItem.title = "Add Place"
        } else {
            showPlaceDetailViewController.place = category.getPlace(indexPath.row)
            showPlaceDetailViewController.navigationItem.title = "Edit Place"
        }
    }

    // MARK: - Table View

    /// Sets the number of sections to display in the tableview.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.getCategoryCount()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories.getCategory(section).getCategoryName()
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        setupGestureRecognizers(headerView, section)
        headerView.textLabel?.text = categories.getCategory(section).getCategoryName()
        headerView.textLabel?.font = UIFont.systemFont(ofSize: 18)
    }
    
    func setupGestureRecognizers(_ headerView: UITableViewHeaderFooterView, _ categoryIndex: Int) {
        let tap = TapGestureRecognizer(target: self, action: #selector(categorySingleTap), categoryIndex: categoryIndex)
        tap.numberOfTapsRequired = 1
        let doubleTap = TapGestureRecognizer(target: self, action: #selector(categoryDoubleTap), categoryIndex: categoryIndex)
        doubleTap.numberOfTapsRequired = 2
        let press = PressGestureRecognizer(target: self, action: #selector(categoryPressed), categoryIndex: categoryIndex)
        tap.require(toFail: doubleTap)
        headerView.addGestureRecognizer(tap)
        headerView.addGestureRecognizer(doubleTap)
        headerView.addGestureRecognizer(press)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = categories.getCategory(section)
        return category.isCategoryCollapsed() ? 0 : category.getPlaceCount() + 1
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

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return categories.getCategory(indexPath.section).getPlaceCount() == indexPath.row ? false : true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceCategory = categories.getCategory(sourceIndexPath.section)
        let destinationCategory = categories.getCategory(destinationIndexPath.section)
        if destinationIndexPath.row >= destinationCategory.getPlaceCount() {
            destinationCategory.insertPlace(sourceCategory.getPlace(sourceIndexPath.row), destinationCategory.getPlaceCount())
        } else {
            destinationCategory.insertPlace(sourceCategory.getPlace(sourceIndexPath.row), destinationIndexPath.row)
        }
        sourceCategory.removePlace(sourceIndexPath.row)
        categories.saveData()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let category = categories.getCategory(indexPath.section)
        if editingStyle == .delete {
            category.removePlace(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            categories.saveData()
        }
    }
    
    // MARK: - Gesture Recognizers
    
    /// Toggle Category collapse
    /// - Parameters:
    ///     - sender: The tap gesture that initiated the collapse.
    @objc
    func categorySingleTap(_ sender: TapGestureRecognizer) {
        categories.getCategory(sender.categoryIndex).collapseCategory()
        tableView.reloadSections(IndexSet([sender.categoryIndex]), with: .automatic)
    }
    
    /// Segues to the Category Detail View to allow the user to edit the Category name.
    /// - Parameters:
    ///     - sender: The tap gesture that initiated the segue.
    @objc
    func categoryDoubleTap(_ sender: TapGestureRecognizer) {
        performSegue(withIdentifier: "showCategoryDetailView", sender: sender)
    }
    
    /// Present the Remove Category Modal View allowing the user to remove a Category.
    /// - Parameters:
    ///     - sender: The press gesture that initiated the removal process.
    @objc
    func categoryPressed(_ sender: PressGestureRecognizer) {
        performSegue(withIdentifier: "showRemoveCategoryModal", sender: sender)
    }

    // MARK: - Favourite Places Delegates
    
    /// Saves any changes made.
    func save() {
        if !isInSplitView() {
            navigationController?.popViewController(animated: true)
        }
        categories.saveData()
        tableView.reloadData()
    }
    
    /// Checks if the display is in split view.
    /// - Returns: true if the display is in split view.
    func isInSplitView() -> Bool {
        guard let isCollapsed = splitViewController?.isCollapsed else { return false }
        return !isCollapsed
    }
    
    /// Used to dismiss modal views.
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    /// Handles the deletion of T objects.
    /// - Parameters:
    ///     - object: The object that is to be deleted.
    func delete<T>(_ object: T) {
        if object as? Place != nil , let index = categories.findEmptyPlace(){
            let category = categories.getCategory(index)
            category.removePlace(category.getPlaceCount() - 1)
            tableView.reloadSections(IndexSet([index]), with: .automatic)
        } else if let category = object as? Category, let index = categories.removeCategory(category) {
            if index < tableView.numberOfSections {
                dismiss(animated: true) { [weak self] in
                    self?.deleteCategory(index)
                }
            } else {
                deleteCategory(index)
            }
        }
        if !isInSplitView() {
            navigationController?.popViewController(animated: true)
        }
        categories.saveData()
    }
    
    /// Deletes the Category, animates, and reloads the table after 1 second.
    /// - Parameters:
    ///     - index: The index of the Category.
    func deleteCategory(_ index: Int) {
        tableView.deleteSections(IndexSet([index]), with: .automatic)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.tableView.reloadData()
        }
    }
}

