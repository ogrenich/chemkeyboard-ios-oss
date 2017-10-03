//
//  KeyboardViewModel.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class KeyboardViewModel {
    
    fileprivate let bag = DisposeBag()
    
    let selectedCategory = Variable<ElementCategory?>(nil)
    let selectedSymbolGroup = Variable<SymbolGroup?>(nil)
    
    let categories = Variable<[ElementCategory]>([])
    let symbolGroups = Variable<[SymbolGroup]>([])
    
    init() {
        setUpRealm()
    }
    
}

private extension KeyboardViewModel {
    
    func setUpRealm() {
        RealmService.instance.setUpRealm()
        RealmService.instance.performMigration()
    }
    
}
