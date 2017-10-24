//
//  UIImage+Extensions.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 23/10/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

public extension UIImage {
    
    convenience public init?(color: UIColor,
                             size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else {
            return nil
        }
        
        self.init(cgImage: cgImage)
    }
    
}

public extension UIImage {
    
    public func mask(with color: UIColor) -> UIImage? {
        let maskLayer = CALayer()
        
        maskLayer.bounds = CGRect(x: 0,
                                  y: 0,
                                  width: size.width,
                                  height: size.height)
        
        maskLayer.backgroundColor = color.cgColor
        maskLayer.applyMask(by: self)
        return maskLayer.toImage()
    }
    
}
