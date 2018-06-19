//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Iurii Plugatarov on 18/06/2018.
//  Copyright © 2018 Iurii Plugatarov. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
  var categories: Results<Category>?
  
  let realm = try! Realm()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadCategories()
  }
  
  // MARK: - TableView datasource methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
    return cell
  }
  
  // MARK: - Data manipulation methods
  func save(category: Category) {
    do {
      try realm.write {
        realm.add(category)
      }
    } catch {
      print("Error saving category, \(error)")
    }
    
    self.tableView.reloadData()
  }
  
  func loadCategories() {
    categories = realm.objects(Category.self)
    
    tableView.reloadData()
  }
  
  // MARK: - Add new categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      let newCategory = Category()
      newCategory.name = textField.text!
      
      self.save(category: newCategory)
    }
    
    alert.addAction(action)
    
    alert.addTextField() { (field) in
      textField = field
      textField.placeholder = "Add new category"
    }
    
    present(alert, animated: true, completion: nil)
  }
  
  // MARK: - TableView delegate methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItem", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categories?[indexPath.row]
    }
  }
  
  override func updateModel(at: IndexPath) {
    if let categoryForDeletion = self.categories?[at.row] {
      do {
        try self.realm.write {
          self.realm.delete(categoryForDeletion)
        }
      } catch {
        print("delete error")
      }
      
    }
  }
}
