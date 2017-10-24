//
//  Button.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 23/10/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

@IBDesignable
public class Button: UIButton {
    
    @IBInspectable var normalBackgroundColor: UIColor? = nil
    @IBInspectable var highlightedBackgroundColor: UIColor? = nil
    @IBInspectable var disabledBackgroundColor: UIColor? = nil
    
    @IBInspectable var normalImageColor: UIColor? = nil
    @IBInspectable var highlightedImageColor: UIColor? = nil
    @IBInspectable var disabledImageColor: UIColor? = nil
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        customize()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        customize()
    }
    
}

public extension Button {
    
    public func customize() {
        if let normalBackgroundColor = normalBackgroundColor {
            setBackgroundImage(UIImage(color: normalBackgroundColor),
                               for: .normal)
        }
        
        if let highlightedBackgroundColor = highlightedBackgroundColor {
            setBackgroundImage(UIImage(color: highlightedBackgroundColor),
                               for: .highlighted)
        }
        
        if let disabledBackgroundColor = disabledBackgroundColor {
            setBackgroundImage(UIImage(color: disabledBackgroundColor),
                               for: .disabled)
        }
        
        if let normalImageColor = normalImageColor {
            let normalImage = image(for: .normal)?
                .mask(with: normalImageColor)
            
            setImage(normalImage, for: .normal)
        }
        
        if let highlightedImageColor = highlightedImageColor {
            let highlightedImage = image(for: .highlighted)?
                .mask(with: highlightedImageColor)
            
            setImage(highlightedImage, for: .highlighted)
        }
        
        if let disabledImageColor = disabledImageColor {
            let disabledImage = image(for: .disabled)?
                .mask(with: disabledImageColor)
            
            setImage(disabledImage, for: .disabled)
        }
    }
    
}
