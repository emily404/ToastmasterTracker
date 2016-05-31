//
//  RoleLog.swift
//  TMTracker
//
//  Created by Emily Chen on 2016-05-31.
//  Copyright © 2016 Emily Chen. All rights reserved.
//

import UIKit
import RealmSwift

class RoleLog: Object {

    dynamic var name: String = ""
    dynamic var minute = 0
    dynamic var seconds = 0
    dynamic var fillerCount = 0
    
//    init(name: String) {
//        self.name = name
//    }
    
//    required init(realm: RLMRealm, schema: RLMObjectSchema) {
//        fatalError("init(realm:schema:) has not been implemented")
//    }

}
