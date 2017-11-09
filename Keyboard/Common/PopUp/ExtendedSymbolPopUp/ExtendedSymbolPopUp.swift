//
//  ExtendedSymbolPopUp.swift
//  Keyboard
//
//  Created by Maria Dagaeva on 19.10.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import Neon

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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutFrames()
    }

}

extension ExtendedSymbolPopUp {
    
    func configure(with symbol: Symbol, _ cellWidth: CGFloat,
                   alignment: UIView.Alignment) -> ExtendedSymbolPopUp {
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
            label.sizeToFit()
            label.textAlignment = .center
            
            addSubview(label)
        }
        
    }
    
}

private extension ExtendedSymbolPopUp {
    
    func layoutFrames() {
        let symbolCorner: Corner = (alignment == .left) ? .topRight : .topLeft
        let indexCorner: Corner = (alignment == .left) ? .topLeft : .topRight
        
        let symbolWidth = max(symbolLabel.width, width - 28)
        let indexWidth = max(topIndexLabel.width, 12)
        
        symbolLabel.anchorInCorner(symbolCorner, xPad: 6, yPad: 6,
                                   width: symbolWidth, height: 32)
        topIndexLabel.anchorInCorner(indexCorner, xPad: 4, yPad: 4,
                                     width: indexWidth, height: 18)
        bottomIndexLabel.anchorInCorner(indexCorner, xPad: 4, yPad: 4 + 18,
                                        width: indexWidth, height: 18)
    }
    
}
