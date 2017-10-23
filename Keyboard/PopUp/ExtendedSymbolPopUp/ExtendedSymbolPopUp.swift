//
//  ExtendedSymbolPopUp.swift
//  Keyboard
//
//  Created by Maria Dagaeva on 19.10.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

extension ExtendedSymbolPopUp {
    
    enum Label {
        case symbol, topIndex, bottomIndex
    }
    
}

class ExtendedSymbolPopUp: UIView {

    fileprivate let symbolLabel: UILabel = UILabel()
    fileprivate let topIndexLabel: UILabel = UILabel()
    fileprivate let bottomIndexLabel: UILabel = UILabel()
    
    var alignment: UIView.Alignment!

}

extension ExtendedSymbolPopUp {
    
    func configure(with symbol: Symbol, _ cellWidth: CGFloat, alignment: UIView.Alignment) -> ExtendedSymbolPopUp {
        self.alignment = alignment
        
        backgroundColor = .white
        
        accessoryShape(radius: 4, heightOfCell: 52, widthOfCell: cellWidth, alignment: alignment)
        
        setUpLabels(with: symbol)
        selectLabel(.symbol)
        
        return self
    }
    
    func selectLabel(_ label: Label) {
        [symbolLabel, topIndexLabel, bottomIndexLabel].forEach { label in
            label.backgroundColor = .clear
            label.textColor = .black
        }
        
        switch label {
        case .symbol:
            symbolLabel.backgroundColor = .black
            symbolLabel.textColor = .white
        case .topIndex:
            topIndexLabel.backgroundColor = .black
            topIndexLabel.textColor = .white
        case .bottomIndex:
            bottomIndexLabel.backgroundColor = .black
            bottomIndexLabel.textColor = .white
        }
    }
    
}

private extension ExtendedSymbolPopUp {
    
    func setUpLabels(with symbol: Symbol) {
        symbolLabel.font = UIFont(name: "SFUIDisplay-Medium", size: 21)
        symbolLabel.cornerRadius = 5
        symbolLabel.layer.masksToBounds = true
        
        [topIndexLabel, bottomIndexLabel].forEach { label in
            label.font = UIFont(name: "SFUIDisplay-Medium", size: 12)
            label.cornerRadius = 3
            label.layer.masksToBounds = true
        }
        
        [symbolLabel, topIndexLabel, bottomIndexLabel].forEach { label in
            label.text = symbol.value ?? ""
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
        }
        
        symbolLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 18).isActive = true
        symbolLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        [topIndexLabel, bottomIndexLabel].forEach { label in
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 12).isActive = true
            label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        }
        
        symbolLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        topIndexLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        bottomIndexLabel.topAnchor.constraint(equalTo: topIndexLabel.bottomAnchor).isActive = true
        topIndexLabel.widthAnchor.constraint(equalTo: bottomIndexLabel.widthAnchor).isActive = true
        
        switch alignment {
        case .left:
            symbolLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6).isActive = true
            topIndexLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
            bottomIndexLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
            symbolLabel.leadingAnchor.constraint(equalTo: topIndexLabel.trailingAnchor, constant: 4).isActive = true
        default:
            symbolLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6).isActive = true
            topIndexLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
            bottomIndexLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
            topIndexLabel.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 4).isActive = true
        }
    }
    
}
