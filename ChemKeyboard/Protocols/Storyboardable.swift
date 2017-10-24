//
//  Storyboardable.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 23/10/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

protocol Storyboardable: class {
    
    static var storyboardIdentifier: String { get }
    static var storyboard: UIStoryboard { get }
    
}

extension Storyboardable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static var storyboard: UIStoryboard {
        switch storyboardIdentifier {
        case String(describing: InstructionsViewController.self):
            return UIStoryboard(.main)
        case String(describing: MainViewController.self):
            return UIStoryboard(.main)
        default:
            return UIStoryboard(.main)
        }
    }
    
    
    static func instantiateFromStoryboard() -> Self {
        let viewController: Self = UIStoryboard.instantiateViewController()
        return viewController
    }
    
}
