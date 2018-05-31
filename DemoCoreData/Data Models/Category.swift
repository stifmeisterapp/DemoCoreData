//
//  Category.swift
//  DemoCoreData
//
//  Created by Callsoft on 28/05/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import Foundation
import RealmSwift
class Category:Object{
    @objc dynamic var name = ""
    let items = List<Item>()
}

