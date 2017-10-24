//
//  SymbolGroup.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation
import RealmSwift

class SymbolGroup: Object {
    
    @objc dynamic var name: String?
    let numberOfSymbolsInLine = RealmOptional<Int>()
    
    var symbols = List<Symbol>()
    
}
