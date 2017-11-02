//
//  ExtendedElementPopUp.swift
//  Keyboard
//
//  Created by Maria Dagaeva on 18.10.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

class ExtendedElementPopUp: UIView {

    fileprivate let symbolLabel: UILabel = UILabel()
    fileprivate let numberLabel: UILabel = UILabel()
    fileprivate let molarMassLabel: UILabel = UILabel()
    fileprivate let nameLabel: UILabel = UILabel()
    fileprivate let electronConfigurationLabel: UILabel = UILabel()

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
            label.adjustsFontSizeToFitWidth = true
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
        }
        
        [symbolLabel, nameLabel, electronConfigurationLabel].forEach { label in
            label.textColor = element.category?.textColor?.hexColor ?? .black
            label.textAlignment = .left
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6).isActive = true
        }
        [numberLabel, molarMassLabel].forEach { label in
            label.textColor = (element.category?.textColor?.hexColor ?? .black).withAlphaComponent(0.5)
            label.textAlignment = .right
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6).isActive = true
        }
        
        symbolLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        symbolLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 34).isActive = true
        [numberLabel, molarMassLabel, nameLabel, electronConfigurationLabel].forEach { label in
            label.heightAnchor.constraint(equalToConstant: 14).isActive = true
        }
        
        symbolLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        nameLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor).isActive = true
        electronConfigurationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        molarMassLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor).isActive = true
        
        molarMassLabel.leadingAnchor.constraint(greaterThanOrEqualTo: symbolLabel.trailingAnchor).isActive = true
        numberLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true
        electronConfigurationLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true
    }
    
}
