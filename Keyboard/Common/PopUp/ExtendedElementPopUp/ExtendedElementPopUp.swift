//
//  ExtendedElementPopUp.swift
//  Keyboard
//
//  Created by Maria Dagaeva on 18.10.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import Neon

class ExtendedElementPopUp: UIView {

    fileprivate let symbolLabel: UILabel = UILabel()
    fileprivate let numberLabel: UILabel = UILabel()
    fileprivate let molarMassLabel: UILabel = UILabel()
    fileprivate let nameLabel: UILabel = UILabel()
    fileprivate let electronConfigurationLabel: UILabel = UILabel()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutFrames()
    }

}

extension ExtendedElementPopUp {
    
    func configure(with element: Element) -> ExtendedElementPopUp {
        backgroundColor = element.category?.color?.hexColor
        
        accessoryShape(radius: 4, heightOfCell: 44, widthOfCell: 58, alignment: .center)
        
        setUpLabels(with: element)
        
        return self
    }
    
}

private extension ExtendedElementPopUp {
    
    func setUpLabels(with element: Element) {
        symbolLabel.font = UIFont(name: "SFUIDisplay-Bold", size: 32)
        [numberLabel, molarMassLabel, nameLabel, electronConfigurationLabel].forEach { label in
            label.font = UIFont(name: "SFUIDisplay-Bold", size: 11)
        }
        
        symbolLabel.text = element.symbol?.value ?? ""
        numberLabel.text = element.number.value != nil ? "\(element.number.value!)" : ""
        molarMassLabel.text = element.molarMass.value != nil ? "\(element.molarMass.value!)" : ""
        nameLabel.text = element.name ?? ""
        electronConfigurationLabel.text = element.electronConfiguration ?? ""
        
        [symbolLabel, numberLabel, molarMassLabel, nameLabel, electronConfigurationLabel].forEach { label in
            label.sizeToFit()
            label.adjustsFontSizeToFitWidth = true
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
        }
        
        [symbolLabel, nameLabel, electronConfigurationLabel].forEach { label in
            label.textColor = element.category?.textColor?.hexColor ?? .black
            label.textAlignment = .left
        }
        [numberLabel, molarMassLabel].forEach { label in
            label.textColor = (element.category?.textColor?.hexColor ?? .black).withAlphaComponent(0.5)
            label.textAlignment = .right
        }
    }
    
}

private extension ExtendedElementPopUp {
    
    func layoutFrames() {
        var symbolWidth = symbolLabel.width
        var molarMassWidth = molarMassLabel.width
        if (symbolWidth + molarMassWidth) > width - 12 {
            symbolWidth -= 6
            molarMassWidth = width - 12 - symbolWidth
        }
        
        let electronConfigurationWidth = min(electronConfigurationLabel.width, width - 12)
        
        symbolLabel.anchorInCorner(.topLeft,
                                   xPad: 6, yPad: 0,
                                   width: symbolWidth, height: 34)
        numberLabel.anchorInCorner(.topRight, xPad: 6, yPad: 6, width: numberLabel.width, height: 14)
        molarMassLabel.anchorInCorner(.topRight, xPad: 6, yPad: 6 + 14, width: molarMassWidth, height: 14)
        nameLabel.anchorInCorner(.topLeft, xPad: 6, yPad: 34, width: nameLabel.width, height: 14)
        electronConfigurationLabel.anchorInCorner(.topLeft, xPad: 6, yPad: 34 + 14,
                                                  width: electronConfigurationWidth, height: 14)
    }
    
}
