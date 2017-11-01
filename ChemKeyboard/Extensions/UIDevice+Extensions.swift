//
//  UIDevice+Extensions.swift
//  ChemKeyboard
//
//  Created by Maria Dagaeva on 31.10.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    enum DevicePlatform: String {
        case other = "Old Device"
        case iPhone6S = "iPhone 6S"
        case iPhone6SPlus = "iPhone 6S Plus"
        case iPhone7 = "iPhone 7"
        case iPhone7Plus = "iPhone 7 Plus"
    }
    
    var platform: DevicePlatform {
        get {
            let platform: String
            if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                platform = simulatorModelIdentifier
            } else {
                var sysinfo = utsname()
                uname(&sysinfo)
                platform = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
            }
            
            switch platform {
            case "iPhone9,2", "iPhone9,4":
                return .iPhone7Plus
            case "iPhone9,1", "iPhone9,3":
                return .iPhone7
            case "iPhone8,2":
                return .iPhone6SPlus
            case "iPhone8,1":
                return .iPhone6S
            default:
                return .other
            }
        }
    }
    
    public var hasTapticEngine: Bool {
        get {
            return platform == .iPhone6S || platform == .iPhone6SPlus ||
                platform == .iPhone7 || platform == .iPhone7Plus
        }
    }
    
    public var hasHapticFeedback: Bool {
        get {
            return platform == .iPhone7 || platform == .iPhone7Plus
        }
    }
}
