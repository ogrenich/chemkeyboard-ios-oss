//
//  ElementService.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 03/10/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

class ElementService {
    
    static let instance = ElementService()
    
    fileprivate let bag = DisposeBag()
    fileprivate let realm = try! Realm()
    
    let categories = Variable<[ElementCategory]>([])
    
    
    init() {
        bindSelf()
    }
    
}

private extension ElementService {
    
    func bindSelf() {
        Observable.array(from: realm.objects(ElementCategory.self))
            .subscribe(onNext: { [weak self] in
                self?.categories.value = $0
            })
            .disposed(by: bag)
    }
    
}
