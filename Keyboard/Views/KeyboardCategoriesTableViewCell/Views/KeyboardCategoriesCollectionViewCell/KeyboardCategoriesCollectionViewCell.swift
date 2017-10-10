//
//  KeyboardCategoriesCollectionViewCell.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

class KeyboardCategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedBackgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            selectedBackgroundImageView.isHidden = !isSelected
        }
    }
    
}

extension KeyboardCategoriesCollectionViewCell {
    
    @discardableResult
    func configure(with category: ElementCategory,
                   selected: Bool) -> KeyboardCategoriesCollectionViewCell {
        nameLabel.text = category.name
        isSelected = selected
        
        return self
    }
    
}
