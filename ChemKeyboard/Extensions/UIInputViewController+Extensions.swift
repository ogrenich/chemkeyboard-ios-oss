//
//  UIInputViewController+Extensions.swift
//  ChemKeyboard
//
//  Created by Maria Dagaeva on 16.11.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

public extension UIInputViewController {
    
    public var returnKeyString: String {
        if let type = textDocumentProxy.returnKeyType {
            switch type {
            case .`default`:
                return "RETURN"
            case .go:
                return "GO"
            case .google:
                return "GOOGLE"
            case .join:
                return "JOIN"
            case .next:
                return "NEXT"
            case .route:
                return "ROUTE"
            case .search:
                return "SEARCH"
            case .send:
                return "SEND"
            case .yahoo:
                return "YAHOO"
            case .done:
                return "DONE"
            case .emergencyCall:
                return "EMERGENCY CALL"
            case .`continue`:
                return "CONTINUE"
            }
        }
        return "RETURN"
    }
    
}
