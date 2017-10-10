//
//  Iteratable.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation

public protocol Iteratable { }

public extension Iteratable where Self: RawRepresentable, Self: Hashable {
    
    public static func hashValues() -> AnyIterator<Self> {
        return iterateEnum(self)
    }
    
    public static func rawValues() -> [Self.RawValue] {
        return hashValues()
            .map { $0.rawValue }
    }
    
    public static func cases() -> [Self] {
        return Array(hashValues())
    }
    
}

public extension RawRepresentable where Self: RawRepresentable {
    
    public static func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        
        return AnyIterator {
            let next = withUnsafePointer(to: &i) {
                $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee }
            }
            
            if next.hashValue != i {
                return nil
            }
            
            i += 1
            
            return next
        }
    }
    
}
