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
    
    @IBOutlet weak var iconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalSpaceBetweenIconAndTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalSpaceBetweenTitleAndStepsViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalSpaceBetweenButtonAndStepsViewConstraint: NSLayoutConstraint!

    
    fileprivate let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindSelf()
        configureConstraints()
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
    
    func configureConstraints() {
        switch UIScreen.main.bounds.height {
        case 0...568:
            iconHeightConstraint.constant = 170
            verticalSpaceBetweenIconAndTitleConstraint.constant = -4
            verticalSpaceBetweenTitleAndStepsViewConstraint.constant = 16
            verticalSpaceBetweenButtonAndStepsViewConstraint.constant = 0
        case 569...667:
            iconHeightConstraint.constant = 212
            verticalSpaceBetweenIconAndTitleConstraint.constant = 12
            verticalSpaceBetweenTitleAndStepsViewConstraint.constant = 22
            verticalSpaceBetweenButtonAndStepsViewConstraint.constant = 18
        case 668...736:
            iconHeightConstraint.constant = 270
            verticalSpaceBetweenIconAndTitleConstraint.constant = 8
            verticalSpaceBetweenTitleAndStepsViewConstraint.constant = 22
            verticalSpaceBetweenButtonAndStepsViewConstraint.constant = 34
        default:
            iconHeightConstraint.constant = 270
            verticalSpaceBetweenIconAndTitleConstraint.constant = 46
            verticalSpaceBetweenTitleAndStepsViewConstraint.constant = 22
            verticalSpaceBetweenButtonAndStepsViewConstraint.constant = 44
        }
    }
    
}
