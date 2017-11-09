//
//  SimpleSymbolPopUp.swift
//  Keyboard
//
//  Created by Maria Dagaeva on 18.10.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import Neon

class SimpleSymbolPopUp: UIView {

    fileprivate let symbolLabel: UILabel = UILabel()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        symbolLabel.anchorAndFillEdge(.top, xPad: 6, yPad: 6, otherSize: 32)
    }

}

extension SimpleSymbolPopUp {
    
    func configure(with symbol: Symbol) -> SimpleSymbolPopUp {
        backgroundColor = .white
        cornerRadius = 4
        
        setUpLabel(with: symbol)
        
        return self
    }
    
}

private extension SimpleSymbolPopUp {
    
    func setUpLabel(with symbol: Symbol) {
        symbolLabel.font = UIFont(name: "SFUIDisplay-Medium", size: 21)
        symbolLabel.cornerRadius = 5
        symbolLabel.layer.masksToBounds = true
        
        symbolLabel.text = symbol.value ?? ""
        symbolLabel.adjustsFontSizeToFitWidth = true
        symbolLabel.textAlignment = .center
        
        addSubview(symbolLabel)
    }
    
}
