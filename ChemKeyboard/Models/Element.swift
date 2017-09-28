//
//  Element.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Element: Object, Mappable {
    
    @objc dynamic var symbol: Symbol? = nil                 // Short name of element ("Al", for example)
    @objc dynamic var name: String? = nil                   // Full name of element ("Alumnium", for example)
    @objc dynamic var electronConfiguration: String? = nil  // Electron Configuration ("[Ne] 3s2 3p1", for example)
    @objc dynamic var category: ElementCategory? = nil      // Category ("Basic Metal", for example)
    
    let number = RealmOptional<Int>()                       // The serial number of the element (number of protons)
    let period = RealmOptional<Int>()                       // The period (row) number in the Mendeleev's table
    let group = RealmOptional<Int>()                        // The group (column) number in the Mendeleev's table, 1...18
    let molarMass = RealmOptional<Double>()                 // Molar mass
    let electronegativity = RealmOptional<Double>()         // The relative electronegativity of the element by Pauling
    let valence = RealmOptional<Int>()                      // Valence
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        symbol                  <- map["symbol"]
        name                    <- map["name"]
        electronConfiguration   <- map["electronConfiguration"]
        category                <- map["category"]
        
        number.value            <- map["number"]
        period.value            <- map["period"]
        group.value             <- map["group"]
        molarMass.value         <- map["molarMass"]
        electronegativity.value <- map["electronegativity"]
        valence.value           <- map["valence"]
    }
    
}
