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
    
    fileprivate let buttonView = UIView()
    fileprivate let firstLabel = UILabel()
    fileprivate let secondLabel = UILabel()
    fileprivate let thirdLabel = UILabel()
    fileprivate let fourthLabel = UILabel()
    
    fileprivate let accessoryView = UIView()
    fileprivate let leftView = UIView()
    fileprivate let rightView = UIView()
    
    fileprivate let topView = UIView()
    fileprivate let bottomView = UIView()
    
    fileprivate var subviewsHierarchyHasBeenConfigured: Bool = false
    
    
    override var isSelected: Bool {
        didSet {
            buttonView.layer.mask = nil
            
            buttonView.roundCorners(corners: isSelected ? [.bottomLeft, .bottomRight] : .allCorners,
                                    radius: 8)
            
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
        clipsToBounds = false
        backgroundColor = .clear
        
        buttonView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
        topView.backgroundColor = .clear
        bottomView.backgroundColor = .clear
        
        configureLabels(with: group)
        configureAccessoryView()
        
        if !subviewsHierarchyHasBeenConfigured {
            configureSubviewsHierarchy()
        }
        
        layoutFrames()
        
        isSelected = selected
        
        return self
    }
    
}

private extension KeyboardActionsCollectionViewCell {
    
    func configureLabels(with group: SymbolGroup) {
        [firstLabel, thirdLabel, secondLabel, fourthLabel].forEach { label in
            label.font = UIFont(name: "SFUIDisplay-Bold", size: 12)
            label.backgroundColor = .clear
            label.alpha = 0.35
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
        }
        
        switch group.name {
        case "Digits"?:
            firstLabel.text = "0"
            secondLabel.text = "1"
            thirdLabel.text = "2"
            fourthLabel.text = "3"
        case "Actions"?:
            firstLabel.text = "+"
            secondLabel.text = "–"
            thirdLabel.text = "/"
            fourthLabel.text = ")"
        case "Arrows"?:
            firstLabel.text = "→"
            secondLabel.text = "="
            thirdLabel.text = "⇋"
            fourthLabel.text = "⇠"
        case "Conditions"?:
            firstLabel.text = "(l)"
            secondLabel.text = "(aq)"
            thirdLabel.text = "(g)"
            fourthLabel.text = "(s)"
        case "Special Symbols"?:
            firstLabel.text = "℃"
            secondLabel.text = "(t)"
            thirdLabel.text = "pH"
            fourthLabel.text = "(p)"
        case "Greek"?:
            firstLabel.text = "ψ"
            secondLabel.text = "ω"
            thirdLabel.text = "α"
            fourthLabel.text = "β"
        default:
            break
        }
    }
    
    func configureAccessoryView() {
        accessoryView.clipsToBounds = true
        accessoryView.backgroundColor = buttonView.backgroundColor
        [leftView, rightView].forEach { view in
            view.backgroundColor = .white
            view.cornerRadius = 8
        }
    }
    
    func configureSubviewsHierarchy() {
        addSubview(buttonView)
        if Device.isPad() {
            [firstLabel, thirdLabel, secondLabel, fourthLabel].forEach { label in
                buttonView.addSubview(label)
            }
        } else {
            topView.addSubview(firstLabel)
            topView.addSubview(secondLabel)
            bottomView.addSubview(thirdLabel)
            bottomView.addSubview(fourthLabel)
            buttonView.addSubview(topView)
            buttonView.addSubview(bottomView)
        }
        
        addSubview(accessoryView)
        [leftView, rightView].forEach { view in
            accessoryView.addSubview(view)
        }
        
        subviewsHierarchyHasBeenConfigured = true
    }
    
}

private extension KeyboardActionsCollectionViewCell {
    
    func layoutFrames() {
        buttonView.fillSuperview(left: 0, right: 0, top: 0, bottom: 0)
        
        switch Device.type() {
        case .iPad:
            buttonView.groupAndFill(group: .horizontal,
                                    views: [firstLabel, secondLabel, thirdLabel, fourthLabel],
                                    padding: 8)
        default:
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                topView.fillSuperview(left: 6, right: 6, top: 2, bottom: 0.5 * height)
                bottomView.fillSuperview(left: 6, right: 6, top: 0.5 * height, bottom: 2)
            } else {
                topView.fillSuperview(left: 3, right: 3, top: 2, bottom: 0.5 * height)
                bottomView.fillSuperview(left: 3, right: 3, top: 0.5 * height, bottom: 2)
            }
            topView.groupAndFill(group: .horizontal, views: [firstLabel, secondLabel], padding: 1)
            bottomView.groupAndFill(group: .horizontal, views: [thirdLabel, fourthLabel], padding: 1)
        }
        
        accessoryView.fillSuperview(left: -8, right: -8, top: -6, bottom: height)
        leftView.fillSuperview(left: -8, right: accessoryView.width - 8, top: 0, bottom: -6)
        rightView.fillSuperview(left: accessoryView.width - 8, right: -8, top: 0, bottom: -6)
    }
    
}
