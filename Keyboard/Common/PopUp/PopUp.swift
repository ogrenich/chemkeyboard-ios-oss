//
//  PopUp.swift
//  Keyboard
//
//  Created by Maria Dagaeva on 17.10.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

extension PopUp {
    
    enum PopUpStyle {
        case simple, extended
    }
    
}

class PopUp {
    
    static let instance = PopUp()
    
    var keyboardView: UIView!
    fileprivate var popUpView: UIView!
    fileprivate var contentView: UIView!
    
}

extension PopUp {
    
    func show(element: Element, at frame: CGRect, style: PopUpStyle) {
        hide()
        
        switch style {
        case .extended:
            if frame.origin.y - 70 < 0 {
                fallthrough
            }
            
            let frameForPopUp = CGRect(x: frame.origin.x - 15,
                                       y: frame.origin.y - 70,
                                       width: 88, height: 114)
            popUpView = UIView(frame: frameForPopUp)
            addContentView(with: element, style: .extended)
        case .simple:
            let frameForPopUp = CGRect(x: frame.origin.x - 8,
                                       y: frame.origin.y - 40,
                                       width: 74, height: 84)
            popUpView = UIView(frame: frameForPopUp)
            addContentView(with: element, style: .simple)
        }
        
        setUpShadow(with: element.category?.shadowColor?.hexColor ?? .black,
                    radius: 14, offset: CGSize(width: 0, height: 1))
        keyboardView.addSubview(popUpView)
    }
    
    func show(symbol: Symbol, at frame: CGRect, style: PopUpStyle) {
        hide()
        
        switch style {
        case .simple:
            let frameForPopUp = CGRect(x: frame.origin.x,
                                       y: frame.origin.y - 50,
                                       width: frame.width,
                                       height: 100)
            popUpView = UIView(frame: frameForPopUp)
            contentView = SimpleSymbolPopUp(frame: popUpView.bounds).configure(with: symbol)
        case .extended:
            if frame.maxX + 18 > UIScreen.main.bounds.width {
                let frameForPopUp = CGRect(x: frame.origin.x - 18,
                                           y: frame.origin.y - 50,
                                           width: frame.width + 18,
                                           height: 100)
                popUpView = UIView(frame: frameForPopUp)
                contentView = ExtendedSymbolPopUp(frame: popUpView.bounds).configure(with: symbol,
                                                                                     frame.width,
                                                                                     alignment: .left)
            } else {
                let frameForPopUp = CGRect(x: frame.origin.x,
                                           y: frame.origin.y - 50,
                                           width: frame.width + 18,
                                           height: 100)
                popUpView = UIView(frame: frameForPopUp)
                contentView = ExtendedSymbolPopUp(frame: popUpView.bounds).configure(with: symbol,
                                                                                     frame.width,
                                                                                     alignment: .right)
            }
        }
        
        addConstraints()
        setUpShadow(with: "#1d000000".hexColor, radius: 12, offset: CGSize(width: 2, height: 5))
        keyboardView.addSubview(popUpView)
    }
    
    func select(at point: CGPoint) {
        if let contentView = contentView as? ExtendedSymbolPopUp {
            let userDraggedToIndex: Bool = (contentView.alignment == .right) ?
                (point.x > popUpView.frame.maxX - 18) : (point.x < popUpView.frame.origin.x + 18)
            
            if userDraggedToIndex {
                if point.y < popUpView.frame.origin.y + 22 {
                    contentView.selectLabel(.topIndex)
                } else {
                    contentView.selectLabel(.bottomIndex)
                }
            } else {
                contentView.selectLabel(.symbol)
            }
        }
    }
    
    func hide() {
        contentView?.removeFromSuperview()
        popUpView?.removeFromSuperview()
    }
    
}

private extension PopUp {
    
    func addConstraints() {
        popUpView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: popUpView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor).isActive = true
    }
    
    func addContentView(with element: Element, style: PopUpStyle) {
        switch style {
        case .simple:
            contentView = SimpleElementPopUp(frame: popUpView.bounds).configure(with: element)
        case .extended:
            contentView = ExtendedElementPopUp(frame: popUpView.bounds).configure(with: element)
        }
        
        addConstraints()
    }
    
    func setUpShadow(with color: UIColor, radius: CGFloat, offset: CGSize) {
        popUpView.shadowRadius = radius
        popUpView.shadowColor = color
        popUpView.shadowOffset = offset
        popUpView.shadowOpacity = 1
        
        if let path = (contentView.layer.mask as? CAShapeLayer)?.path {
            popUpView.layer.shadowPath = path
        }
    }
    
}
