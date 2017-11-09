//
//  SimpleElementPopUp.swift
//  Keyboard
//
//  Created by Maria Dagaeva on 17.10.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import Neon

class SimpleElementPopUp: UIView {

    fileprivate let symbolLabel: UILabel = UILabel()
    fileprivate let numberLabel: UILabel = UILabel()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutFrames()
    }

}

extension SimpleElementPopUp {
    
    func configure(with element: Element) -> SimpleElementPopUp {
        backgroundColor = element.category?.color?.hexColor
        
        accessoryShape(radius: 4, heightOfCell: 44, widthOfCell: 58, alignment: .center)
        
        setUpLabels(with: element)
        
        return self
    }
    
}

private extension SimpleElementPopUp {
    
    func setUpLabels(with element: Element) {
        symbolLabel.font = UIFont(name: "SFUIDisplay-Medium", size: 21)
        numberLabel.font = UIFont(name: "SFUIDisplay-Bold", size: 10)
        
        symbolLabel.textColor = element.category?.textColor?.hexColor ?? .black
        numberLabel.textColor = (element.category?.textColor?.hexColor ?? .black).withAlphaComponent(0.5)
        
        symbolLabel.text = element.symbol?.value ?? ""
        numberLabel.text = element.number.value != nil ? "\(element.number.value!)" : ""
        
        symbolLabel.sizeToFit()
        numberLabel.sizeToFit()
        
        addSubview(symbolLabel)
        addSubview(numberLabel)
    }
    
}

private extension SimpleElementPopUp {
    
    func layoutFrames() {
        symbolLabel.anchorInCorner(.topLeft,
                                   xPad: 6, yPad: 3,
                                   width: symbolLabel.width, height: 25)
        numberLabel.anchorInCorner(.topRight,
                                   xPad: 6, yPad: 3,
                                   width: numberLabel.width, height: 12)
    }
    
}
