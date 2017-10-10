//
//  SymbolService.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 03/10/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

class SymbolService {
    
    static let instance = SymbolService()
    
    fileprivate let bag = DisposeBag()
    fileprivate let realm = try! Realm()
    
    let groups = Variable<[SymbolGroup]>([])
    
    
    init() {
        bindSelf()
    }
    
}

private extension SymbolService {
    
    func bindSelf() {
        Observable.array(from: realm.objects(SymbolGroup.self))
            .subscribe(onNext: { [weak self] in
                self?.groups.value = $0
            })
            .disposed(by: bag)
    }
    
}
