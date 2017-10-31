//
//  KeyboardCategoriesCollectionViewCell.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import Device

class KeyboardCategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedBackgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    
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
        
        switch Device.type() {
        case .iPad:
            leadingConstraint.constant = 6
            trailingConstraint.constant = 6
        default:
            leadingConstraint.constant = 0
            trailingConstraint.constant = 0
        }
        
        return self
    }
    
}
