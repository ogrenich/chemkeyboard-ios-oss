//
//  InstructionsViewController.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 23/10/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InstructionsViewController: UIViewController, Storyboardable {

    @IBOutlet weak var closeButton: Button!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var goToSettingsButton: Button!

    
    fileprivate let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindSelf()
    }
    
}

private extension InstructionsViewController {
    
    func bindSelf() {
        closeButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: bag)
        
        goToSettingsButton.rx.tap
            .bind {
                var preferencePath: String
                
                if #available(iOS 11.0, *) {
                    preferencePath = UIApplicationOpenSettingsURLString
                } else {
                    preferencePath = "App-Prefs:root=General&path=Keyboard"
                }
                
                if let url = URL(string: preferencePath) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url,
                                                  options: [:],
                                                  completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            .disposed(by: bag)
    }
    
}
