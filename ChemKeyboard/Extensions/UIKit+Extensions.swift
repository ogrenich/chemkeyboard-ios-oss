//
//  UIKit+Extensions.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 01/11/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

var isOpenAccessGranted: Bool = {
    if #available(iOSApplicationExtension 10.0, *) {
        let originalString = UIPasteboard.general.string
        UIPasteboard.general.string = "Test"
        
        if UIPasteboard.general.hasStrings {
            UIPasteboard.general.string = originalString
            return true
        } else {
            return false
        }
    } else {
        return UIPasteboard.general.isKind(of: UIPasteboard.self)
    }
}()
