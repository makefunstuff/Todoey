//
//  Category.swift
//  Todoey
//
//  Created by Iurii Plugatarov on 19/06/2018.
//  Copyright © 2018 Iurii Plugatarov. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name: String = ""
  @objc dynamic var color: String = ""
  
  let items = List<Item>()
}
