//
//  Symbol.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation
import RealmSwift

class Symbol: Object {
    
    @objc dynamic var value: String?
    @objc dynamic var topIndex: Symbol?
    @objc dynamic var bottomIndex: Symbol?
    
}
