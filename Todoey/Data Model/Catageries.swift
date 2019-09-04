//
//  Catageries.swift
//  Todoey
//
//  Created by ahmad$$ on 4/21/19.
//  Copyright © 2019 ahmad. All rights reserved.
//

import Foundation
import RealmSwift
class Catageries: Object {
    @objc dynamic var name:String = ""
    let items = List<Items>()
}
