//
//  String+Extensions.swift
//  ChemKeyboard
//
//  Created by Maria Dagaeva on 04.10.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

extension String {
    
    var hexColor: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        var rgbValue = UInt32()
        Scanner(string: hex).scanHexInt32(&rgbValue)
        
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (rgbValue >> 8) * 17, (rgbValue >> 4 & 0xF) * 17, (rgbValue & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, rgbValue >> 16, rgbValue >> 8 & 0xFF, rgbValue & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (rgbValue >> 24, rgbValue >> 16 & 0xFF, rgbValue >> 8 & 0xFF, rgbValue & 0xFF)
        default:
            return .clear
        }
        
        return UIColor(red: CGFloat(r) / 255,
                       green: CGFloat(g) / 255,
                       blue: CGFloat(b) / 255,
                       alpha: CGFloat(a) / 255)
    }
    
}

public extension String {
    
    public func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
}
