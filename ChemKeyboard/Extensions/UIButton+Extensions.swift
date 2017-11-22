//
//  UIButton+Extensions.swift
//  ChemKeyboard
//
//  Created by Maria Dagaeva on 16.11.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

public extension UIButton {
    
    public func setTitle(_ title: String?, letterSpacing: CGFloat) {
        if let title = title {
            let attributedString = NSMutableAttributedString(string: title)
            attributedString.addAttribute(NSAttributedStringKey.kern,
                                          value: letterSpacing,
                                          range: NSRange(location: 0, length: title.count))
            setAttributedTitle(attributedString, for: .normal)
        }
    }
    
}
