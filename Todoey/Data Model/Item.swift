//
//  Item.swift
//  Todoey
//
//  Created by Zain Shaikh on 01/12/2018.
//  Copyright © 2018 Zain Shaikh. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategry = LinkingObjects(fromType: Category.self, property: "item")
    
}
