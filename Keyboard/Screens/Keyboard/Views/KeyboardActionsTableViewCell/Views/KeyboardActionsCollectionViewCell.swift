//
//  KeyboardActionsCollectionViewCell.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import Device
import Neon

class KeyboardActionsCollectionViewCell: UICollectionViewCell {
    
    fileprivate lazy var buttonView: UIView = UIView()
    fileprivate lazy var symbolLabel: UILabel = UILabel()
    
    fileprivate lazy var accessoryView: UIView = UIView()
    fileprivate lazy var leftView: UIView = UIView()
    fileprivate lazy var rightView: UIView = UIView()
    
    fileprivate var subviewsHierarchyHasBeenConfigured: Bool = false
    
    
    override var isSelected: Bool {
        didSet {
            buttonView.layer.mask = nil
            
            buttonView.roundCorners(corners: isSelected ? [.bottomLeft, .bottomRight] : .allCorners,
                                    radius: 4)
            
            accessoryView.isHidden = !isSelected
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutFrames()
    }
    
}

extension KeyboardActionsCollectionViewCell {
    
    @discardableResult
    func configure(with group: SymbolGroup,
                   selected: Bool) -> KeyboardActionsCollectionViewCell {
        setupUI()
        
        configureLabel(with: group)
        configureAccessoryView(with: group)
        
        if !subviewsHierarchyHasBeenConfigured {
            configureSubviewsHierarchy()
        }
        
        layoutFrames()
        
        isSelected = selected
        
        return self
    }
    
}

private extension KeyboardActionsCollectionViewCell {
    
    func setupUI() {
        clipsToBounds = false
        backgroundColor = .clear
        
        buttonView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
    }
    
}

private extension KeyboardActionsCollectionViewCell {
    
    func configureLabel(with group: SymbolGroup) {
        symbolLabel.font = UIFont(name: "SFUIDisplay-Bold", size: 14)
        symbolLabel.textColor = #colorLiteral(red: 0.6235294118, green: 0.6235294118, blue: 0.6235294118, alpha: 1)
        symbolLabel.backgroundColor = .clear
        symbolLabel.adjustsFontSizeToFitWidth = true
        symbolLabel.textAlignment = .center
        
        switch group.name {
        case "Digits"?:
            symbolLabel.text = "7"
        case "Actions"?:
            symbolLabel.text = "+"
        case "Arrows"?:
            symbolLabel.text = "→"
        case "Conditions"?:
            symbolLabel.text = "(l)"
        case "Special Symbols"?:
            symbolLabel.text = "℃"
        case "Greek"?:
            symbolLabel.text = "ψ"
        default:
            break
        }
    }
    
    func configureAccessoryView(with group: SymbolGroup) {
        accessoryView.clipsToBounds = true
        accessoryView.backgroundColor = buttonView.backgroundColor
        [leftView, rightView].forEach { view in
            view.backgroundColor = .white
        }
        leftView.cornerRadius = (group.name != "Digits" || Device.isPad()) ? 6 : 0
        rightView.cornerRadius = (group.name != "Greek" || Device.isPad()) ? 6 : 0
    }
    
    func configureSubviewsHierarchy() {
        addSubview(buttonView)
        buttonView.addSubview(symbolLabel)
        
        addSubview(accessoryView)
        [leftView, rightView].forEach { view in
            accessoryView.addSubview(view)
        }
        
        subviewsHierarchyHasBeenConfigured = true
    }
    
}

private extension KeyboardActionsCollectionViewCell {
    
    func layoutFrames() {
        buttonView.fillSuperview()
        
        symbolLabel.fillSuperview()
        
        accessoryView.fillSuperview(left: -6, right: -6, top: Device.isPad() ? -8 : -6, bottom: height)
        leftView.fillSuperview(left: -6, right: accessoryView.width - 6, top: 0, bottom: Device.isPad() ? -8 : -6)
        rightView.fillSuperview(left: accessoryView.width - 6, right: -6, top: 0, bottom: Device.isPad() ? -8 : -6)
    }
    
}
