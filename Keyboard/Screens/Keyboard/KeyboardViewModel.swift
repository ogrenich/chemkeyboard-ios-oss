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
        
        bindSelf()
        bindToOutputs()
    }
    
}

private extension KeyboardViewModel {
    
    func setUpRealm() {
        RealmService.instance.setUpRealm()
    }
    
}

private extension KeyboardViewModel {
    
    func bindSelf() {
        ElementService.instance.categories.asObservable()
            .map { $0.filter { $0.elements.count > 0 } }
            .bind(to: categories)
            .disposed(by: bag)
        
        SymbolService.instance.groups.asObservable()
            .bind(to: symbolGroups)
            .disposed(by: bag)
    }
    
    func bindToOutputs() {
        categories.asObservable()
            .map { $0.first }
            .bind(to: selectedCategory)
            .disposed(by: bag)
        
        symbolGroups.asObservable()
            .map { $0.first }
            .bind(to: selectedSymbolGroup)
            .disposed(by: bag)
    }
    
}
