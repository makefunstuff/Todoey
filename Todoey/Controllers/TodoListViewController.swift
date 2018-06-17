//
//  ViewController.swift
//  Todoey
//
//  Created by Iurii Plugatarov on 17/06/2018.
//  Copyright © 2018 Iurii Plugatarov. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var itemArray = [Item]()
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadItems()
  }
  
  // MARK: - Tableview Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
    let item = itemArray[indexPath.row]
    
    cell.textLabel?.text = item.title
   
    cell.accessoryType = item.done ? .checkmark : .none
    
    return cell
  }
  
  // MARK: - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done

    saveItems()
    
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  // MARK: - Add New Items
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      let newItem = Item(context: self.context)
      
      newItem.title = textField.text!
      newItem.done = false
      
      self.itemArray.append(newItem)
      
      self.saveItems()
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
      
    }
    
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
    
  }
  
  // MARK: - Model Manupulation Methods
  
  func saveItems() {
    do {
      try context.save()
    } catch {
      print("Error saving context \(error)")
    }
    
    self.tableView.reloadData()
  }
  
  func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
    do {
      itemArray = try context.fetch(request)
    } catch {
      print("Error fetching data \(error)")
    }
    
    tableView.reloadData()
  }
  
}
// MARK: - Search Bar Methods
extension TodoListViewController : UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    let request : NSFetchRequest<Item> = Item.fetchRequest()
    
    request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

    loadItems(with: request)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadItems()
      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
    }
  }
}
