//
//  KeyboardSymbolsCollectionViewCell.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class KeyboardSymbolsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var symbolLabel: UILabel!
    
    
    fileprivate weak var cellTouchDown: PublishSubject<KeyboardSymbolsCollectionViewCell>?
    fileprivate weak var cellTouchUp: PublishSubject<KeyboardSymbolsCollectionViewCell>?
    fileprivate weak var cellDrag: PublishSubject<KeyboardSymbolsCollectionViewCell>?
    
    
    fileprivate var gesture: UILongPressGestureRecognizer!
    
    
    fileprivate var symbol: Symbol!
    
    var chosenSymbol: Symbol? = nil
    var pointOfTouch: CGPoint? = nil

}

extension KeyboardSymbolsCollectionViewCell {
    
    @discardableResult
    func configure(with symbol: Symbol, corners: UIRectCorner = [],
                   cellTouchDown: PublishSubject<KeyboardSymbolsCollectionViewCell>?,
                   cellTouchUp: PublishSubject<KeyboardSymbolsCollectionViewCell>?,
                   cellDrag: PublishSubject<KeyboardSymbolsCollectionViewCell>?) -> KeyboardSymbolsCollectionViewCell {
        self.symbol = symbol
        self.cellTouchDown = cellTouchDown
        self.cellTouchUp = cellTouchUp
        self.cellDrag = cellDrag
        
        symbolLabel.text = symbol.value
        roundCorners(corners: corners, radius: 4)
        
        if gesture == nil {
            addTouchEvents()
        }
        
        return self
    }
    
}

extension KeyboardSymbolsCollectionViewCell {
    
    func addTouchEvents() {
        gesture = UILongPressGestureRecognizer(target: self,
                                               action: #selector(longPressHandler))
        
        gesture.minimumPressDuration = 0
        addGestureRecognizer(gesture)
    }
    
    @objc func longPressHandler() {
        switch gesture.state {
        case .began:
            chosenSymbol = symbol
            cellTouchDown?.onNext(self)
        case .changed:
            let pointOfTouch = gesture.location(in: self)
            cellDrag?.onNext(self)
            
            let userDraggedToIndex = (frame.maxX + 18 > UIScreen.main.bounds.width) ?
                (pointOfTouch.x < 0) : (pointOfTouch.x > bounds.maxX)
            
            if userDraggedToIndex {
                if pointOfTouch.y > -28 {
                    chosenSymbol = symbol.bottomIndex ?? symbol
                } else {
                    chosenSymbol = symbol.topIndex ?? symbol
                }
            } else {
                chosenSymbol = symbol
            }
            
            self.pointOfTouch = pointOfTouch
        case .ended, .cancelled, .failed:
            cellTouchUp?.onNext(self)
        default:
            break
        }
    }
    
}
