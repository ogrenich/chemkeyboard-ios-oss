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
            if !isEnabled {
                sublayer.backgroundColor = disabledBackgroundColor?.cgColor
            } else {
                sublayer.backgroundColor = normalBackgroundColor?.cgColor
            }
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                sublayer.backgroundColor = highlightedBackgroundColor?.cgColor
            } else {
                sublayer.backgroundColor = normalBackgroundColor?.cgColor
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        updateSublayer()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpSublayer()
    }
    
}

private extension Button {
    
    func setUpSublayer() {
        sublayer.frame = bounds
        sublayer.masksToBounds = true
        sublayer.backgroundColor = normalBackgroundColor?.cgColor
        layer.backgroundColor = UIColor.white.cgColor
        layer.insertSublayer(sublayer, below: nil)
    }
    
    func updateSublayer() {
        if sublayer.cornerRadius != cornerRadius {
            sublayer.cornerRadius = cornerRadius
        }
    }
    
}
