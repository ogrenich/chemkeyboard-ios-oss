//
//  CALayer+Extensions.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 23/10/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

public extension CALayer {
    
    public func applyMask(by image: UIImage) {
        let maskLayer = CAShapeLayer()
        
        maskLayer.bounds = CGRect(x: 0,
                                  y: 0,
                                  width: image.size.width,
                                  height: image.size.height)
        
        bounds = maskLayer.bounds
        maskLayer.contents = image.cgImage
        
        maskLayer.frame = CGRect(x: 0,
                                 y: 0,
                                 width: frame.size.width,
                                 height: frame.size.height)
        
        mask = maskLayer
    }
    
    public func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size,
                                               isOpaque,
                                               UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        render(in: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
