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
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
      print("delete cell")
      
//      if let categoryForDeletion = self.categories?[indexPath.row] {
//        do {
//          try self.realm.write {
//            self.realm.delete(categoryForDeletion)
//          }
//        } catch {
//          print("delete error")
//        }
      
      }
      
      deleteAction.image = UIImage(named: "delete-icon")
      return [deleteAction]
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

