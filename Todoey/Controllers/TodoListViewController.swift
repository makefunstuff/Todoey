//
//  ViewController.swift
//  Todoey
//
//  Created by Iurii Plugatarov on 17/06/2018.
//  Copyright © 2018 Iurii Plugatarov. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
  let realm = try! Realm()
  var todoItems : Results<Item>?
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  var selectedCategory : Category? {
    didSet {
      loadItems()
    }
  }
  
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.separatorStyle = .none
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if let colorHex = selectedCategory?.color {
      guard let navBar = navigationController?.navigationBar else {
        fatalError("Navigation controller does not exist")
      }
      title = selectedCategory!.name
      let barTintColor: UIColor? = UIColor(hexString: colorHex)
      navBar.barTintColor = barTintColor
      searchBar.barTintColor = barTintColor
      
      navBar.tintColor = ContrastColorOf(barTintColor!, returnFlat: true)
      navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: navBar.tintColor]
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    guard let originalColor = UIColor(hexString: "1D9BF6") else { fatalError() }
    navigationController?.navigationBar.barTintColor = originalColor
    navigationController?.navigationBar.tintColor = FlatWhite()
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: FlatWhite()]
  }
  
  // MARK: - Tableview Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoItems?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    if let item = todoItems?[indexPath.row] {
      cell.textLabel?.text = item.title
      let percentage = CGFloat(indexPath.row) / CGFloat((todoItems?.count)!)
      
      if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: percentage) {
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
      }
      
      cell.accessoryType = item.done ? .checkmark : .none
    } else {
      cell.textLabel?.text = "No Items Added"
    }
    
    return cell
  }
  
  // MARK: - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    do {
      if let item = todoItems?[indexPath.row] {
        try realm.write {
          item.done = !item.done
        }
      }
    } catch {
      print("Could not toggle record")
    }
    
    tableView.reloadData()
    
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  // MARK: - Add New Items
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      if let currentCategory = self.selectedCategory {
        do {
          try self.realm.write {
            let newItem = Item()
            newItem.title = textField.text!
            currentCategory.items.append(newItem)
            newItem.dateCreated = Date()
          }
          
        } catch {
          print("could not save object")
        }
        
        self.tableView.reloadData()
      }
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
      
    }
    
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
    
  }
  
  // MARK: - Model Manupulation Methods
  

  func loadItems() {
    todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    
    tableView.reloadData()
  }
  
  override func updateModel(at: IndexPath) {
    if let item = todoItems?[at.row] {
      do {
        try realm.write {
          realm.delete(item)
        }
      } catch {
        print("Delete error")
      }
    }
  }
  
}
//// MARK: - Search Bar Methods
extension TodoListViewController : UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    tableView.reloadData()
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
