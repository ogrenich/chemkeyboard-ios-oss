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
    
    var realmURL: URL? = Realm.Configuration.defaultConfiguration.fileURL
    
}

extension RealmService {
    
    func setUpRealm() {
        guard
            let resourceURL = Bundle.main.url(forResource: "ChemKeyboard",
                                              withExtension: "realm"),
            let realmDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                         .userDomainMask,
                                                                         true).first
        else {
            return
        }
        
        let realmPath = realmDirectoryPath + "/ChemKeyboard.realm"
        realmURL = URL(fileURLWithPath: realmPath)
        
        guard let realmURL = realmURL else {
            return
        }
        
        if FileManager.default.fileExists(atPath: realmPath) {
            do {
                _ = try FileManager.default.replaceItemAt(realmURL,
                                                          withItemAt: resourceURL)
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                try FileManager.default.copyItem(at: resourceURL, to: realmURL)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func performMigration() {
        guard let realmURL = realmURL else {
            return
        }
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            fileURL: realmURL,
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 3 { // the old (default) version is 0
                    
                }
            }
        )
    }
    
    func printRealmURL() {
        print(realmURL ?? "Realm not found")
    }
    
    func writeRealmCopyToResources() {
        guard
            let documentDirectory = try? FileManager.default.url(for: .documentDirectory,
                                                                 in: .userDomainMask,
                                                                 appropriateFor: nil,
                                                                 create: true)
        else {
            return
        }
        
        let fileURL = documentDirectory.appendingPathComponent("ChemKeyboard.realm")
        
        do {
            try Realm().writeCopy(toFile: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
