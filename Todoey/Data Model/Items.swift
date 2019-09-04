//
//  Data.swift
//  Todoeyx
//
//  Created by ahmad$$ on 4/21/19.
//  Copyright © 2019 ahmad. All rights reserved.
//

import Foundation
import RealmSwift
// class of type Object used to define Realm model objects
class Items : Object {
    // @objc : thet refers thet the code come from objectivc programming langauge
    //dynamic : added to make the variabel suitabel for Realme I.E the vriabel can be observed by Realm so if it changed the Realm update it immediatly
    @objc dynamic var title :String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    
    var parentCategry = LinkingObjects(fromType: Catageries.self, property: "items")
}
