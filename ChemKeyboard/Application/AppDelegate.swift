//
//  AppDelegate.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 25/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let instance: AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()

    
    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setUpMainInterface()
        setUpFabric()
        
        return true
    }

}

private extension AppDelegate {
    
    func setUpMainInterface() {
        guard let window = AppDelegate.instance.window else {
            return
        }
        
        let root = MainViewController.instantiateFromStoryboard()
        
        if UserDefaults.standard.hasLaunchedBefore == false {
            DispatchQueue.main.async {
                root.performSegue(withIdentifier: "InstructionsWithoutAnimation",
                                  sender: nil)
            }
            
            UserDefaults.standard.hasLaunchedBefore = true
        }
        
        window.rootViewController = root
    }
    
    func setUpFabric() {
        Fabric.with([Crashlytics.self])
    }
    
}
