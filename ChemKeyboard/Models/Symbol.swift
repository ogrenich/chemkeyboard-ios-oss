//
//  Symbol.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Symbol: Object, Mappable {
    
    @objc dynamic var value: String? = nil
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        value   <- map["value"]
    }
    
}
