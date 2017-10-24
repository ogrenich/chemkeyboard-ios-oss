//
//  UserDefaults+Extensions.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 23/10/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    var hasLaunchedBefore: Bool {
        get {
            return bool(forKey: #function)
        }
        
        set {
            set(newValue, forKey: #function)
        }
    }
    
}
