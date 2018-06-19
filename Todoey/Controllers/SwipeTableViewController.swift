//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Iurii Plugatarov on 19/06/2018.
//  Copyright © 2018 Iurii Plugatarov. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = 80
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
      print("delete cell")
      
      self.updateModel(at: indexPath)
      
    }
    
    deleteAction.image = UIImage(named: "delete-icon")
    
    return [deleteAction]
  }
  
  
  func updateModel(at: IndexPath) {
    print("Item deleted")
  }
  
  func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
    var options = SwipeTableOptions()
    options.expansionStyle = .destructive
    return options
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
    
    cell.delegate = self
    
    return cell
  }

}

