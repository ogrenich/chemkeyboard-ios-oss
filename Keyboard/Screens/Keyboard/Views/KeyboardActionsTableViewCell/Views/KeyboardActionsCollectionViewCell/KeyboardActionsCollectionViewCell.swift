//
//  KeyboardActionsCollectionViewCell.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

class KeyboardActionsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    
    fileprivate var accessoryView: UIView!
    
    
    override var isSelected: Bool {
        didSet {
            buttonView.layer.mask = nil
            
            buttonView.roundCorners(corners: isSelected ? [.bottomLeft, .bottomRight] : .allCorners,
                                    radius: 8)
            
            accessoryView?.isHidden = !isSelected
        }
    }
    
}

private extension KeyboardActionsCollectionViewCell {
    
    func configureLabels(with group: SymbolGroup) {
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
    
}

extension KeyboardActionsCollectionViewCell {
    
    @discardableResult
    func configure(with group: SymbolGroup,
                   selected: Bool) -> KeyboardActionsCollectionViewCell {
        configureLabels(with: group)
        
        if accessoryView == nil {
            configureAccessoryView()
        }
        
        isSelected = selected
        
        return self
    }
    
}

extension KeyboardActionsCollectionViewCell {
    
    func configureAccessoryView() {
        let collectionViewTopInset: CGFloat = 6
        let cellPadding: CGFloat = 8
        
        accessoryView = UIView()
        accessoryView.clipsToBounds = true
        accessoryView.backgroundColor = buttonView.backgroundColor
        
        let leftView = UIView()
        let rightView = UIView()
        
        [leftView, rightView].forEach { view in
            view.backgroundColor = .white
            view.cornerRadius = 8
            
            accessoryView.addSubview(view)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: accessoryView.topAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: accessoryView.bottomAnchor).isActive = true
            view.widthAnchor.constraint(equalToConstant: 2 * cellPadding).isActive = true
        }
        
        leftView.centerXAnchor.constraint(equalTo: accessoryView.leadingAnchor).isActive = true
        rightView.centerXAnchor.constraint(equalTo: accessoryView.trailingAnchor).isActive = true
        
        addSubview(accessoryView)
        accessoryView.translatesAutoresizingMaskIntoConstraints = false
        accessoryView.heightAnchor.constraint(equalToConstant: collectionViewTopInset).isActive = true
        
        accessoryView.widthAnchor.constraint(equalTo: widthAnchor,
                                             constant: 2 * cellPadding).isActive = true
        
        accessoryView.bottomAnchor.constraint(equalTo: topAnchor).isActive = true
        accessoryView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
}
