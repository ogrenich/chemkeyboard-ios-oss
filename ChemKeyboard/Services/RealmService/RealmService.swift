//
//  RealmService.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 29/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    
    static let instance = RealmService()
    
    let server = "ec2-13-228-182-241.ap-southeast-1.compute.amazonaws.com:9080"
    let realmPath = "/ChemKeyboard/default"
    let username = "username@chemopin.tech"
    let password = "qwerty987"
    
}

extension RealmService {
    
    func setUpRealm() {
        if isOpenAccessGranted && UserDefaults.standard.hasLaunchedBefore {
            setUpSyncRealm()
        } else {
            UserDefaults.standard.hasLaunchedBefore = true
            setUpPredefinedRealm()
        }
    }
    
}

private extension RealmService {
    
    func setUpPredefinedRealm() {
        guard let realmURL = Bundle.main.url(forResource: "predefined",
                                             withExtension: "realm") else {
            return
        }
        
        let predefinedConfiguration = Realm.Configuration(
            fileURL: realmURL,
            readOnly: true,
            objectTypes: [
                Element.self,
                ElementCategory.self,
                Symbol.self,
                SymbolGroup.self
            ]
        )
        
        Realm.Configuration.defaultConfiguration = predefinedConfiguration
    }
    
    func setUpSyncRealm() {
        let credentials = SyncCredentials.usernamePassword(username: username,
                                                           password: password)
        
        let serverURL = URL(string: "http://" + server)!
        
        SyncUser.logIn(with: credentials, server: serverURL) { [weak self] user, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                ElementService.instance.fetchCategories()
                SymbolService.instance.fetchGroups()
            }
            
//            self?.writeSyncRealmCopyToFile()
        }
    }
    
}

private extension RealmService {
    
    func writeSyncRealmCopyToFile() {
        guard let user = SyncUser.current else {
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
                        callback: { realm, error in
            guard let realm = realm else {
                if let error = error {
                    print(error.localizedDescription)
                }
                
                return
            }
            
            guard
                let documentDirectory = try? FileManager.default.url(for: .documentDirectory,
                                                                     in: .userDomainMask,
                                                                     appropriateFor: nil,
                                                                     create: true)
            else {
                return
            }
            
            let fileURL = documentDirectory.appendingPathComponent("predefined.realm")
            
            do {
                try realm.writeCopy(toFile: fileURL)
            } catch {
                print(error)
            }
        })
    }

}
