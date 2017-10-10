//
//  NibLoadable.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

public protocol NibLoadable: class {
    
    static var nibName: String { get }
    
}

public extension NibLoadable where Self: NSCoding {
    
    public static var nibName: String {
        return String(describing: self)
    }
    
}
