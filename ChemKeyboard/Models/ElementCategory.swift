//
//  ElementCategory.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class ElementCategory: Object, Mappable {
    
    @objc dynamic var name: String? = nil
    @objc dynamic var color: String? = nil
    
    var elements = List<Element>()
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name        <- map["name"]
        color       <- map["color"]
        
        elements    <- (map["elements"], ListTransform<Element>())
    }
    
}
