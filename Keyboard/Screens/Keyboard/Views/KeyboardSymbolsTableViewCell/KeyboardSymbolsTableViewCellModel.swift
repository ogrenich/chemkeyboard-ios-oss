//
//  KeyboardSymbolsTableViewCellModel.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation
import RxSwift

class KeyboardSymbolsTableViewCellModel {
    
    fileprivate let bag = DisposeBag()
    
    
    weak var selectedSymbolGroup: Variable<SymbolGroup?>!
    
    
    init(with selectedSymbolGroup: Variable<SymbolGroup?>) {
        self.selectedSymbolGroup = selectedSymbolGroup
    }
    
}
