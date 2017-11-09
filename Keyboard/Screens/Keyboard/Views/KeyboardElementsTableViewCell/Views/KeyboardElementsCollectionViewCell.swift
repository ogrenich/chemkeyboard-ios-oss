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
    
    fileprivate lazy var symbolLabel: UILabel = UILabel()
    fileprivate lazy var numberLabel: UILabel = UILabel()
    
    fileprivate weak var needsToShowExtendedPopUp: PublishSubject<KeyboardElementsCollectionViewCell>!
    
    fileprivate var subviewsHierarchyHasBeenConfigured: Bool = false
    var popUpExtended: Bool = false
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.force == touch.maximumPossibleForce && !popUpExtended && isHighlighted {
            needsToShowExtendedPopUp.onNext(self)
            popUpExtended = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutFrames()
    }
    
}

extension KeyboardElementsCollectionViewCell {
    
    @discardableResult
    func configure(with element: Element,
                   _ needsToShowExtendedPopUp: PublishSubject<KeyboardElementsCollectionViewCell>) -> KeyboardElementsCollectionViewCell {
        self.needsToShowExtendedPopUp = needsToShowExtendedPopUp
        
        backgroundColor = element.category?.color?.hexColor
        cornerRadius = 4
        shadowRadius = 4
        shadowOffset = CGSize(width: 0, height: 1)
        shadowOpacity = 1
        shadowColor = element.category?.shadowColor?.hexColor
        
        configureSymbolLabel(with: element)
        configureNameLabel(with: element)
        
        if !subviewsHierarchyHasBeenConfigured {
            configureSubviewsHierarchy()
        }
        
        return self
    }
    
}

private extension KeyboardElementsCollectionViewCell {
    
    func configureSymbolLabel(with element: Element) {
        symbolLabel.font = UIFont(name: "SFUIDisplay-Medium", size: 21)
        symbolLabel.textColor = element.category?.textColor?.hexColor ?? .black
        symbolLabel.textAlignment = .left
        symbolLabel.text = element.symbol?.value
        symbolLabel.sizeToFit()
    }
    
    func configureNameLabel(with element: Element) {
        numberLabel.font = UIFont(name: "SFUIDisplay-Bold", size: 10)
        numberLabel.textColor = (element.category?.textColor?.hexColor ?? .black).withAlphaComponent(0.5)
        numberLabel.textAlignment = .right
        numberLabel.text = element.number.value != nil ? "\(element.number.value!)" : ""
        numberLabel.sizeToFit()
    }
    
    func configureSubviewsHierarchy() {
        addSubview(symbolLabel)
        addSubview(numberLabel)
        
        subviewsHierarchyHasBeenConfigured = true
    }
    
}

private extension KeyboardElementsCollectionViewCell {
    
    func layoutFrames() {
        symbolLabel.anchorInCorner(.topLeft,
                                   xPad: 6, yPad: 6,
                                   width: symbolLabel.intrinsicContentSize.width, height: 26)
        numberLabel.anchorInCorner(.topRight,
                                   xPad: 6, yPad: 6,
                                   width: numberLabel.intrinsicContentSize.width, height: 12)
    }
    
}
