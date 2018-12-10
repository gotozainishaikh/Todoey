//
//  Category.swift
//  Todoey
//
//  Created by Zain Shaikh on 01/12/2018.
//  Copyright © 2018 Zain Shaikh. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
    
    @objc dynamic var name: String = ""
    var item = List<Item>()
    @objc dynamic var colorBG = ""
    
}
