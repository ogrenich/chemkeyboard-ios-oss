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
    }
    
    func show(symbol: Symbol, at frame: CGRect, style: PopUpStyle) {
    
    func hide() {
    }
    
}
