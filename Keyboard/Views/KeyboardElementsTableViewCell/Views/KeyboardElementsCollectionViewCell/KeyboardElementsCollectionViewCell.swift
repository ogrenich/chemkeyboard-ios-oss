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
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    fileprivate weak var cellTouchDown: PublishSubject<KeyboardElementsCollectionViewCell>!
    fileprivate weak var cellTouchUp: PublishSubject<KeyboardElementsCollectionViewCell>!
    fileprivate weak var cellTouchLong: PublishSubject<KeyboardElementsCollectionViewCell>!
    
    fileprivate var gesture: UILongPressGestureRecognizer!
    
}

extension KeyboardElementsCollectionViewCell {
    
    @discardableResult
    func configure(with element: Element,
                   cellTouchDown: PublishSubject<KeyboardElementsCollectionViewCell>,
                   cellTouchUp: PublishSubject<KeyboardElementsCollectionViewCell>,
                   cellTouchLong: PublishSubject<KeyboardElementsCollectionViewCell>) -> KeyboardElementsCollectionViewCell {
        self.cellTouchDown = cellTouchDown
        self.cellTouchUp = cellTouchUp
        self.cellTouchLong = cellTouchLong
        
        backgroundColor = element.category?.color?.hexColor
        shadowColor = element.category?.shadowColor?.hexColor
        
        symbolLabel.text = element.symbol?.value
        numberLabel.text = element.number.value != nil ? "\(element.number.value!)" : ""

        symbolLabel.textColor = element.category?.textColor?.hexColor ?? .black
        numberLabel.textColor = (element.category?.textColor?.hexColor ?? .black).withAlphaComponent(0.5)
        
        if gesture == nil {
            addTouchEvents()
        }
        
        return self
    }
    
}

extension KeyboardElementsCollectionViewCell {
    
    func addTouchEvents() {
        gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        gesture.minimumPressDuration = 0
        addGestureRecognizer(gesture)
    }
    
    @objc func longPressHandler() {
        switch gesture.state {
        case .began:
            cellTouchDown.onNext(self)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) { [weak self] in
                guard let `self` = self else {
                    return
                }
                
                if self.gesture.state == .began || self.gesture.state == .changed {
                    self.cellTouchLong.onNext(self)
                }
            }
        case .ended, .cancelled, .failed:
            cellTouchUp.onNext(self)
        default:
            break
        }
    }
    
}
