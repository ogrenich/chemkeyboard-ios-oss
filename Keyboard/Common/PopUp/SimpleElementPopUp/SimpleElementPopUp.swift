//
//  SimpleElementPopUp.swift
//  Keyboard
//
//  Created by Maria Dagaeva on 17.10.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

class SimpleElementPopUp: UIView {

    fileprivate let symbolLabel: UILabel = UILabel()
    fileprivate let numberLabel: UILabel = UILabel()

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
        
        symbolLabel.text = element.symbol?.value ?? ""
        numberLabel.text = element.number.value != nil ? "\(element.number.value!)" : ""
        symbolLabel.textColor = element.category?.textColor?.hexColor ?? .black
        numberLabel.textColor = (element.category?.textColor?.hexColor ?? .black).withAlphaComponent(0.5)
        
        [symbolLabel, numberLabel].forEach { label in
            label.adjustsFontSizeToFitWidth = true
            
            addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        }
        
        symbolLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        numberLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        symbolLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6).isActive = true
        numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6).isActive = true
        
        numberLabel.leadingAnchor.constraint(greaterThanOrEqualTo: symbolLabel.trailingAnchor,
                                             constant: 2).isActive = true
    }
    
}
