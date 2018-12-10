//
//  Data.swift
//  Todoey
//
//  Created by Zain Shaikh on 01/12/2018.
//  Copyright © 2018 Zain Shaikh. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    
}
