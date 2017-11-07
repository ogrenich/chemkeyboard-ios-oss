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
    @IBOutlet weak var iconImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var verticalSpaceBetweenIconImageViewAndTitleLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var stepsView: UIView!
    @IBOutlet weak var verticalSpaceBetweenTitleLabelAndStepsViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var goToSettingsButton: Button!
    @IBOutlet weak var verticalSpaceBetweenStepsViewAndGoToSettingsButtonConstraint: NSLayoutConstraint!

    
    fileprivate let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureConstraints()
        
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
                if let url = URL(string: "App-Prefs:root") {
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
            iconImageViewHeightConstraint.constant = 170
            verticalSpaceBetweenIconImageViewAndTitleLabelConstraint.constant = -4
            verticalSpaceBetweenTitleLabelAndStepsViewConstraint.constant = 16
            verticalSpaceBetweenStepsViewAndGoToSettingsButtonConstraint.constant = 0
        case 569...667:
            iconImageViewHeightConstraint.constant = 212
            verticalSpaceBetweenIconImageViewAndTitleLabelConstraint.constant = 12
            verticalSpaceBetweenTitleLabelAndStepsViewConstraint.constant = 22
            verticalSpaceBetweenStepsViewAndGoToSettingsButtonConstraint.constant = 18
        case 668...736:
            iconImageViewHeightConstraint.constant = 270
            verticalSpaceBetweenIconImageViewAndTitleLabelConstraint.constant = 8
            verticalSpaceBetweenTitleLabelAndStepsViewConstraint.constant = 22
            verticalSpaceBetweenStepsViewAndGoToSettingsButtonConstraint.constant = 34
        default:
            iconImageViewHeightConstraint.constant = 270
            verticalSpaceBetweenIconImageViewAndTitleLabelConstraint.constant = 46
            verticalSpaceBetweenTitleLabelAndStepsViewConstraint.constant = 22
            verticalSpaceBetweenStepsViewAndGoToSettingsButtonConstraint.constant = 44
        }
    }
    
}
