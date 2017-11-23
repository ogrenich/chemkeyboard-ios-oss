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

    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var verticalSpaceBetweenTitleViewAndStepsViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stepsView: UIView!
    @IBOutlet weak var stepsViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stepsViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stepsViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var goToSettingsLabel: UILabel!
    @IBOutlet weak var goToSettingsEmojiLabel: UILabel!
    @IBOutlet weak var tapGeneralLabel: UILabel!
    @IBOutlet weak var tapGeneralEmojiLabel: UILabel!
    @IBOutlet weak var findAndTapKeyboardsLabel: UILabel!
    @IBOutlet weak var findAndTapKeyboardsEmojiLabel: UILabel!
    @IBOutlet weak var tapAddNewKeyboardLabel: UILabel!
    @IBOutlet weak var tapAddNewKeyboardEmojiLabel: UILabel!
    @IBOutlet weak var tapChemKeyboardLabel: UILabel!
    @IBOutlet weak var tapChemKeyboardEmojiLabel: UILabel!
    
    @IBOutlet weak var verticalSpaceBetweenStepsViewAndGoToSettingsButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var goToSettingsButton: Button!
    @IBOutlet weak var goToSettingsButtonBottomConstraint: NSLayoutConstraint!
    
    
    
    fileprivate let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureConstraints()
        
        configureLabels()
        
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
                    UIApplication.shared.open(url,
                                              options: [:],
                                              completionHandler: nil)
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

private extension InstructionsViewController {
    
    private func attributedString(for label: UILabel, length: Int) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: label.text ?? "")
        attributedString.addAttribute(NSAttributedStringKey.font,
                                      value: UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.regular),
                                      range: NSRange(location: 0, length: length))
        return attributedString
    }
    
    func configureLabels() {
        goToSettingsLabel.attributedText = attributedString(for: goToSettingsLabel, length: 5)
        tapGeneralLabel.attributedText = attributedString(for: tapGeneralLabel, length: 3)
        findAndTapKeyboardsLabel.attributedText = attributedString(for: findAndTapKeyboardsLabel, length: 13)
        tapAddNewKeyboardLabel.attributedText = attributedString(for: tapAddNewKeyboardLabel, length: 3)
        tapChemKeyboardLabel.attributedText = attributedString(for: tapChemKeyboardLabel, length: 6)
    }
    
}
