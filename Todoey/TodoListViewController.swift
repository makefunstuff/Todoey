//
//  ViewController.swift
//  Todoey
//
//  Created by Iurii Plugatarov on 17/06/2018.
//  Copyright © 2018 Iurii Plugatarov. All rights reserved.
//

import UIKit

class TodoListViewController : UITableViewController {
  var itemArray: [String] = [String]()
  
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let items = defaults.array(forKey: "TodoListArray") as? [String] {
      itemArray = items
    }
  }

  //MARK - Tableview Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row]
    
    return cell
  }
  
  //MARK - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let currentCell = tableView.cellForRow(at: indexPath)
    
    if currentCell?.accessoryType == .checkmark {
        currentCell?.accessoryType = .none
    } else {
        currentCell?.accessoryType = .checkmark
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //MARK - Add new todo item
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      self.itemArray.append(textField.text!)
      
      self.defaults.set(self.itemArray, forKey: "TodoListArray")
      
      self.tableView.reloadData()
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
  }
}

