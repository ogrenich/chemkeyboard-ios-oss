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

class SymbolService {
    
    static let instance = SymbolService()
    
    fileprivate let bag = DisposeBag()
    
    let groups = Variable<[SymbolGroup]>([])
    
    
    init() {
        bindSyncedRealm()
    }
    
}

private extension SymbolService {
    
    func bindSyncedRealm() {
        let server = "ec2-13-228-182-241.ap-southeast-1.compute.amazonaws.com:9080"
        let realmPath = "/ChemKeyboard/default"
        let username = "username@chemopin.tech"
        let password = "qwerty987"
        
        let credentials = SyncCredentials.usernamePassword(username: username,
                                                           password: password)
        
        let serverURL = URL(string: "http://" + server)!
        
        SyncUser.logIn(with: credentials, server: serverURL) { [weak self] user, error in
            guard let user = user else {
                if let error = error {
                    print(error.localizedDescription)
                }
                
                return
            }
            
            let realmURL = URL(string: "realm://" + server + realmPath)!
            
            let syncedConfiguration = Realm.Configuration(
                syncConfiguration: SyncConfiguration(user: user,
                                                     realmURL: realmURL),
                objectTypes: [
                    Element.self,
                    ElementCategory.self,
                    Symbol.self,
                    SymbolGroup.self
                ]
            )
            
            Realm.asyncOpen(configuration: syncedConfiguration,
                            callbackQueue: .main,
                            callback: { [weak self] realm, error in
                guard let realm = realm else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    return
                }
                                
                self?.groups.value = Array(realm.objects(SymbolGroup.self))
            })
        }
    }
    
}
