//
//  Reusable.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

public protocol Reusable: class {
    
    static var reuseIdentifier: String { get }
    
}

public extension Reusable where Self: UIView {
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
