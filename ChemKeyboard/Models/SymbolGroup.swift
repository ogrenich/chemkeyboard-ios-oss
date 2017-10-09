//
//  SymbolGroup.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class SymbolGroup: Object, Mappable {
    
    @objc dynamic var name: String? = nil
    let numberOfSymbolsInLine = RealmOptional<Int>()
    
    var symbols = List<Symbol>()
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name                        <- map["name"]
        numberOfSymbolsInLine.value <- map["numberOfSymbolsInLine"]
        
        symbols                     <- (map["symbols"], ListTransform<Symbol>())
    }
    
}
