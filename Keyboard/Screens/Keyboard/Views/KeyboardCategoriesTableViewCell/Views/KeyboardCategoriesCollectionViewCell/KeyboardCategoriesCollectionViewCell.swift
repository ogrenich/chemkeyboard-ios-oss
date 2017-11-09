//
//  KeyboardCategoriesCollectionViewCell.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import Device
import Neon

class KeyboardCategoriesCollectionViewCell: UICollectionViewCell {
    
    fileprivate let selectedBackgroundImageView = UIImageView()
    fileprivate let nameLabel = UILabel()
    
    fileprivate var subviewsHierarchyHasBeenConfigured: Bool = false
    
    
    override var isSelected: Bool {
        didSet {
            selectedBackgroundImageView.isHidden = !isSelected
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutFrames()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let preferredAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutFrames()
        var newFrame = preferredAttributes.frame
        newFrame.size.width = (Device.isPad() ? 12 : 0) + selectedBackgroundImageView.width
        newFrame.size.height = 36
        preferredAttributes.frame = newFrame
        return preferredAttributes
    }
    
}

extension KeyboardCategoriesCollectionViewCell {
    
    @discardableResult
    func configure(with category: ElementCategory,
                   selected: Bool) -> KeyboardCategoriesCollectionViewCell {
        nameLabel.text = category.name
        isSelected = selected
        
        backgroundColor = .clear
        
        configureSelectedBackgroundImageView()
        configureNameLabel()
        
        if !subviewsHierarchyHasBeenConfigured {
            configureSubviewsHierarchy()
        }
        
        layoutFrames()
        
        return self
    }
    
}

private extension KeyboardCategoriesCollectionViewCell {
    
    func configureSelectedBackgroundImageView() {
        selectedBackgroundImageView.cornerRadius = 9
        selectedBackgroundImageView.alpha = 0.34
        selectedBackgroundImageView.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8196078431, alpha: 1)
    }
    
    func configureNameLabel() {
        nameLabel.textColor = #colorLiteral(red: 0.6235294118, green: 0.6235294118, blue: 0.6235294118, alpha: 1)
        nameLabel.backgroundColor = .clear
        nameLabel.font = UIFont(name: "SFUIDisplay-Bold", size: 10)
        nameLabel.textAlignment = .center
    }
    
    func configureSubviewsHierarchy() {
        addSubview(selectedBackgroundImageView)
        addSubview(nameLabel)
        
        subviewsHierarchyHasBeenConfigured = true
    }
    
}

private extension KeyboardCategoriesCollectionViewCell {
    
    func layoutFrames() {
        nameLabel.anchorInCenter(width: nameLabel.intrinsicContentSize.width, height: 18)
        selectedBackgroundImageView.anchorInCenter(width: nameLabel.width + 12, height: 18)
    }
    
}
