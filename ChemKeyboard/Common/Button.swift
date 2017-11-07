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
    
    var sublayer: CALayer = CALayer()
    
    
    public override var isEnabled: Bool {
        didSet {
            sublayer.backgroundColor = isEnabled ? normalBackgroundColor?.cgColor : disabledBackgroundColor?.cgColor
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            sublayer.backgroundColor = isHighlighted ?
                highlightedBackgroundColor?.cgColor : normalBackgroundColor?.cgColor
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        updateLayers()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpLayers()
    }
    
}

private extension Button {
    
    func setUpLayers() {
        sublayer.frame = bounds
        sublayer.masksToBounds = true
        sublayer.backgroundColor = normalBackgroundColor?.cgColor
        if shadowOpacity != 0 {
            layer.backgroundColor = superview?.backgroundColor?.cgColor ?? UIColor.white.cgColor
        }
        layer.insertSublayer(sublayer, below: nil)
    }
    
    func updateLayers() {
        if sublayer.cornerRadius != cornerRadius {
            sublayer.cornerRadius = cornerRadius
        }
        if layer.masksToBounds {
            layer.masksToBounds = false
        }
    }
    
}
