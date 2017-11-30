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
import Neon
import Device

class KeyboardSymbolsCollectionViewCell: UICollectionViewCell {
    
    fileprivate lazy var symbolLabel: UILabel = UILabel()
    
    
    fileprivate weak var cellTouchDown: PublishSubject<KeyboardSymbolsCollectionViewCell>?
    fileprivate weak var cellTouchUp: PublishSubject<KeyboardSymbolsCollectionViewCell>?
    fileprivate weak var cellDrag: PublishSubject<KeyboardSymbolsCollectionViewCell>?
    
    
    fileprivate var gesture: UILongPressGestureRecognizer!
    
    
    fileprivate var symbol: Symbol!
    
    var chosenSymbol: Symbol? = nil
    var pointOfTouch: CGPoint? = nil
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        symbolLabel.fillSuperview()
    }

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
        
        roundCorners(corners: corners, radius: 4)
        
        setupUI()
        
        configureSymbolLabel()
        
        if gesture == nil {
            addTouchEvents()
        }
        
        return self
    }
    
}

private extension KeyboardSymbolsCollectionViewCell {
    
    func setupUI() {
        backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
    }
    
}

private extension KeyboardSymbolsCollectionViewCell {
    
    func configureSymbolLabel() {
        if symbolLabel.superview == nil {
            addSubview(symbolLabel)
        }
        
        symbolLabel.text = symbol.value
        symbolLabel.font = Device.isPad() ?
            UIFont(name: "SFUIDisplay-Medium", size: 18) : UIFont(name: "SFUIDisplay-Bold", size: 16)
        symbolLabel.textAlignment = .center
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
