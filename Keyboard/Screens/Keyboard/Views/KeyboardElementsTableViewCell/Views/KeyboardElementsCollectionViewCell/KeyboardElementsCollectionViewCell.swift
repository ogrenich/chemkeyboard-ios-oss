//
//  KeyboardElementsCollectionViewCell.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class KeyboardElementsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
}

extension KeyboardElementsCollectionViewCell {
    
    @discardableResult
    func configure(with element: Element) -> KeyboardElementsCollectionViewCell {
        backgroundColor = element.category?.color?.hexColor
        shadowColor = element.category?.shadowColor?.hexColor
        
        symbolLabel.text = element.symbol?.value
        numberLabel.text = element.number.value != nil ? "\(element.number.value!)" : ""

        symbolLabel.textColor = element.category?.textColor?.hexColor ?? .black
        numberLabel.textColor = (element.category?.textColor?.hexColor ?? .black).withAlphaComponent(0.5)
        
        return self
    }
    
}
