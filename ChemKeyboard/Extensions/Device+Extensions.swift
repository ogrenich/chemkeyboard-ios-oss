//
//  Device+Extensions.swift
//  ChemKeyboard
//
//  Created by Maria Dagaeva on 22.11.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import Device

public extension Device {
    
    public static func isWide() -> Bool {
        return isPad() && (UIScreen.main.bounds.width > UIScreen.main.bounds.height ||
            version() == .iPadPro9_7Inch || version() == .iPadPro10_5Inch || version() == .iPadPro12_9Inch)
    }
    
}
