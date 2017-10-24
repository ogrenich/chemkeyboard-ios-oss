//
//  ElementCategory.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation
import RealmSwift

class ElementCategory: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var color: String?
    @objc dynamic var textColor: String?
    @objc dynamic var shadowColor: String?
    
    var elements = List<Element>()
    
}
