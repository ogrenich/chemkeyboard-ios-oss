//
//  UIView+Extensions.swift
//  ChemKeyboard
//
//  Created by Maria Dagaeva on 05.10.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

@IBDesignable
public extension UIView {
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }

}

public extension UIView {
    
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius,
                                                    height: radius))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    enum Alignment {
        
        case center, left, right
        
    }
    
    public func accessoryShape(radius: CGFloat, heightOfCell: CGFloat, widthOfCell: CGFloat, alignment: Alignment) {
        let (leftInset, rightInset): (CGFloat, CGFloat)
        
        switch alignment {
        case .left:
            (leftInset, rightInset) = (frame.width - widthOfCell, 0)
        case .center:
            (leftInset, rightInset) = (0.5 * (frame.width - widthOfCell),
                                       0.5 * (frame.width - widthOfCell))
        case .right:
            (leftInset, rightInset) = (0, frame.width - widthOfCell)
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: radius))
        
        path.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius,
                    startAngle: CGFloat.pi, endAngle: -0.5 * CGFloat.pi, clockwise: true)
        
        path.addLine(to: CGPoint(x: frame.width - radius, y: 0))
        
        path.addArc(withCenter: CGPoint(x: frame.width - radius, y: radius), radius: radius,
                    startAngle: -0.5 * CGFloat.pi, endAngle: 0, clockwise: true)
        
        path.addLine(to: CGPoint(x: frame.width, y: frame.height - 2 * radius - heightOfCell))
        
        if alignment != .left {
            path.addArc(withCenter: CGPoint(x: frame.width - radius, y: frame.height - 2 * radius - heightOfCell),
                        radius: radius, startAngle: 0, endAngle: 0.5 * CGFloat.pi, clockwise: true)
            
            path.addLine(to: CGPoint(x: frame.width - rightInset + radius,
                                     y: frame.height - radius - heightOfCell))
            
            path.addArc(withCenter: CGPoint(x: frame.width - rightInset + radius,
                                            y: frame.height - heightOfCell),
                        radius: radius, startAngle: -0.5 * CGFloat.pi, endAngle: CGFloat.pi, clockwise: false)
        }
        
        path.addLine(to: CGPoint(x: frame.width - rightInset, y: frame.height - radius))
        
        path.addArc(withCenter: CGPoint(x: frame.width - rightInset - radius,
                                        y: frame.height - radius),
                    radius: radius, startAngle: 0, endAngle: 0.5 * CGFloat.pi, clockwise: true)
        
        path.addLine(to: CGPoint(x: leftInset + radius, y: frame.height))
        
        path.addArc(withCenter: CGPoint(x: leftInset + radius,
                                        y: frame.height - radius), radius: radius,
                    startAngle: 0.5 * CGFloat.pi, endAngle: CGFloat.pi, clockwise: true)
        
        path.addLine(to: CGPoint(x: leftInset, y: frame.height - heightOfCell))
        
        if alignment != .right {
            path.addArc(withCenter: CGPoint(x: leftInset - radius, y: frame.height - heightOfCell),
                        radius: radius, startAngle: 0, endAngle: -0.5 * CGFloat.pi, clockwise: false)
            path.addLine(to: CGPoint(x: radius, y: frame.height - heightOfCell - radius))
            path.addArc(withCenter: CGPoint(x: radius, y: frame.height - 2 * radius - heightOfCell), radius: radius,
                        startAngle: 0.5 * CGFloat.pi, endAngle: CGFloat.pi, clockwise: true)
        }
        
        path.close()
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

public extension UIView {
    
    @IBInspectable
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        
        set {
            layer.shadowOpacity = newValue
            
            if newValue > 0 {
                layer.masksToBounds = false
                
                /// Defining shadow's path for performance improvement
                layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                                cornerRadius: cornerRadius).cgPath
            }
        }
    }
    
    @IBInspectable
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    public var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            
            return nil
        }
        
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
}
