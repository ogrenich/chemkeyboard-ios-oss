//
//  KeyboardSymbolsCollectionViewCell.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

class KeyboardSymbolsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var symbolLabel: UILabel!

}

extension KeyboardSymbolsCollectionViewCell {
    
    @discardableResult
    func configure(with symbol: Symbol) -> KeyboardSymbolsCollectionViewCell {
        symbolLabel.text = symbol.value
        
        return self
    }
    
}
