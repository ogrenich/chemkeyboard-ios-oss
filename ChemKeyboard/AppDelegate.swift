//
//  AppDelegate.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 25/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setUpRealm()
        return true
    }

}

private extension AppDelegate {
    
    func setUpRealm() {
        performRealmMigration()
        printRealmPath()
    }
    
    func performRealmMigration() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 { // the old (default) version is 0
                    
                }
            }
        )
    }
    
    func printRealmPath() {
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "Realm not found")
    }
    
}
