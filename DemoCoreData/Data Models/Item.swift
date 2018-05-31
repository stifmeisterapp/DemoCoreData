//
//  Item.swift
//  DemoCoreData
//
//  Created by Callsoft on 28/05/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import Foundation
import RealmSwift
class Item:Object{
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
