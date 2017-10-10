//
//  KeyboardActionsCollectionViewCell.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

class KeyboardActionsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topLeftLabel: UILabel!
    @IBOutlet weak var topRightLabel: UILabel!
    @IBOutlet weak var bottomLeftLabel: UILabel!
    @IBOutlet weak var bottomRightLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            layer.mask = nil
            
            roundCorners(corners: isSelected ? [.bottomLeft, .bottomRight] : .allCorners,
                         radius: 8)
        }
    }
    
}

private extension KeyboardActionsCollectionViewCell {
    
    func configureLabels(with group: SymbolGroup) {
        switch group.name {
        case "Digits"?:
            topLeftLabel.text = "0"
            topRightLabel.text = "1"
            bottomLeftLabel.text = "2"
            bottomRightLabel.text = "3"
        case "Actions"?:
            topLeftLabel.text = "+"
            topRightLabel.text = "–"
            bottomLeftLabel.text = "/"
            bottomRightLabel.text = ")"
        case "Arrows"?:
            topLeftLabel.text = "→"
            topRightLabel.text = "="
            bottomLeftLabel.text = "⇋"
            bottomRightLabel.text = "⇠"
        case "Group 3"?:
            topLeftLabel.text = "𝞾"
            topRightLabel.text = "𝞰"
            bottomLeftLabel.text = "𝞺"
            bottomRightLabel.text = "𝞛"
        case "Group 4"?:
            topLeftLabel.text = "D"
            topRightLabel.text = "M"
            bottomLeftLabel.text = "C"
            bottomRightLabel.text = "N"
        case "Greek"?:
            topLeftLabel.text = "ψ"
            topRightLabel.text = "ω"
            bottomLeftLabel.text = "α"
            bottomRightLabel.text = "β"
        default:
            break
        }
    }
    
}

extension KeyboardActionsCollectionViewCell {
    
    @discardableResult
    func configure(with group: SymbolGroup, selected: Bool) -> KeyboardActionsCollectionViewCell {
        configureLabels(with: group)
        isSelected = selected
        
        return self
    }
    
}
