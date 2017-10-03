//
//  KeyboardCategoriesCollectionViewCell.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

class KeyboardCategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
}

extension KeyboardCategoriesCollectionViewCell {
    
    @discardableResult
    func configure(with category: ElementCategory) -> KeyboardCategoriesCollectionViewCell {
        nameLabel.text = category.name
        
        return self
    }
    
}
