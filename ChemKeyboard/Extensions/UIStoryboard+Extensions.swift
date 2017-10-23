//
//  UIStoryboard+Extensions.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 23/10/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    enum Storyboard: String {
        
        case main
        
        var name: String {
            return rawValue.capitalizingFirstLetter()
        }
        
    }
    
}

extension UIStoryboard {
    
    convenience init(_ storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.name, bundle: bundle)
    }
    
    class func instantiateViewController<T: UIViewController>() -> T where T: Storyboardable {
        guard let viewController = T.storyboard.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller: \(T.storyboardIdentifier)")
        }
        
        DispatchQueue.main.async {
            viewController.loadViewIfNeeded()
        }
        
        return viewController
    }
    
}
