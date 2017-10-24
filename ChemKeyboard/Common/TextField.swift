//
//  TextField.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 23/10/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

@IBDesignable
public class TextField: UITextField {
    
    @IBInspectable var paddingTop: CGFloat = 0
    @IBInspectable var paddingBottom: CGFloat = 0
    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    
    @IBInspectable var placeholderColor: UIColor?
    
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft,
                      y: bounds.origin.y + paddingTop,
                      width: bounds.size.width - paddingLeft - paddingRight,
                      height: bounds.size.height - paddingTop - paddingBottom)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        customize()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        customize()
    }
    
}

public extension TextField {
    
    public func customize() {
        setValue(placeholderColor, forKeyPath: "_placeholderLabel.textColor")
    }
    
}

