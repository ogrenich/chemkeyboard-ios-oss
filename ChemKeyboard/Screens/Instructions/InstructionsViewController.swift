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
import Neon

extension InstructionsViewController {
    
    enum DeviceType {
        case iPhoneSE, iPhone7, iPhone8Plus, iPhoneX, iPad, iPadWide, iPadHorizontal
    }
    
}

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
    
    
    fileprivate var type: DeviceType = .iPhone7
    
    
    fileprivate let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureConstraints()
        
        bindSelf()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        updateType()
        
        configureLabels()
    }
    
        
}
private extension InstructionsViewController {
    
    func updateType() {
        if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
            type = .iPadHorizontal
        } else {
            switch UIScreen.main.bounds.height {
            case 0...568:
                type = .iPhoneSE
            case 569...667:
                type = .iPhone7
            case 668...736:
                type = .iPhone8Plus
            case 737...812:
                type = .iPhoneX
            case 813...1024:
                type = .iPad
            default:
                type = .iPadWide
            }
        }
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
    
}

private extension InstructionsViewController {
    
    private func attributedString(for label: UILabel, length: Int, size: CGFloat) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: label.text ?? "")
        if let font = UIFont(name: "SFUIDisplay-Regular", size: size) {
            attributedString.addAttribute(NSAttributedStringKey.font, value: font,
                                          range: NSRange(location: 0, length: length))
        }
        return attributedString
    }
    
    func configureConstraints() {
        switch type {
        case .iPhoneSE:
            verticalSpaceBetweenTitleViewAndStepsViewConstraint.constant = 16
            verticalSpaceBetweenStepsViewAndGoToSettingsButtonConstraint.constant = 10
        case .iPhone7:
            verticalSpaceBetweenTitleViewAndStepsViewConstraint.constant = 30
            verticalSpaceBetweenStepsViewAndGoToSettingsButtonConstraint.constant = 30
        case .iPhone8Plus:
            verticalSpaceBetweenTitleViewAndStepsViewConstraint.constant = 30
            verticalSpaceBetweenStepsViewAndGoToSettingsButtonConstraint.constant = 40
        case .iPhoneX:
            verticalSpaceBetweenTitleViewAndStepsViewConstraint.constant = 22
            verticalSpaceBetweenStepsViewAndGoToSettingsButtonConstraint.constant = 44
        case .iPad:
            verticalSpaceBetweenTitleViewAndStepsViewConstraint.constant = 40
            verticalSpaceBetweenStepsViewAndGoToSettingsButtonConstraint.constant = 42
            stepsViewLeadingConstraint.constant = 160
            stepsViewTrailingConstraint.constant = 160
            stepsViewHeightConstraint.constant = 410
            goToSettingsButtonBottomConstraint.constant = 35
        case .iPadWide:
            verticalSpaceBetweenTitleViewAndStepsViewConstraint.constant = 58
            verticalSpaceBetweenStepsViewAndGoToSettingsButtonConstraint.constant = 410
            stepsViewLeadingConstraint.constant = 0
            stepsViewTrailingConstraint.constant = 0
            stepsViewHeightConstraint.constant = 264
            goToSettingsButtonBottomConstraint.constant = 35
        case .iPadHorizontal:
            verticalSpaceBetweenTitleViewAndStepsViewConstraint.constant = -30
            verticalSpaceBetweenStepsViewAndGoToSettingsButtonConstraint.constant = 157
            stepsViewLeadingConstraint.constant = 0
            stepsViewTrailingConstraint.constant = 0
            stepsViewHeightConstraint.constant = 260
            goToSettingsButtonBottomConstraint.constant = 35
        }
    }
    
    func configureLabels() {
        var fontSize: CGFloat = 0
        
        [goToSettingsLabel, tapGeneralLabel, findAndTapKeyboardsLabel,
         tapAddNewKeyboardLabel, tapChemKeyboardLabel].forEach { label in
            switch type {
            case .iPhoneSE, .iPhone7, .iPhone8Plus, .iPhoneX:
                fontSize = 15
                titleLabel.textAlignment = .left
                titleLabel.font = UIFont(name: "SFUIDisplay-Semibold", size: 30)
                label?.textAlignment = .left
            case .iPad:
                fontSize = 24
                titleLabel.textAlignment = .center
                titleLabel.font = UIFont(name: "SFUIDisplay-Semibold", size: 42)
                label?.textAlignment = .left
            case .iPadWide:
                fontSize = 18
                titleLabel.textAlignment = .center
                titleLabel.font = UIFont(name: "SFUIDisplay-Semibold", size: 42)
                label?.textAlignment = .center
            case .iPadHorizontal:
                fontSize = 15
                titleLabel.textAlignment = .left
                titleLabel.font = UIFont(name: "SFUIDisplay-Semibold", size: 42)
                label?.textAlignment = .center
            }
            
            label?.font = UIFont(name: "SFUIDisplay-Semibold", size: fontSize)
        }
        
        goToSettingsLabel.attributedText = attributedString(for: goToSettingsLabel, length: 5, size: fontSize)
        tapGeneralLabel.attributedText = attributedString(for: tapGeneralLabel, length: 3, size: fontSize)
        findAndTapKeyboardsLabel.attributedText = attributedString(for: findAndTapKeyboardsLabel, length: 13, size: fontSize)
        tapAddNewKeyboardLabel.attributedText = attributedString(for: tapAddNewKeyboardLabel, length: 3, size: fontSize)
        tapChemKeyboardLabel.attributedText = attributedString(for: tapChemKeyboardLabel, length: 6, size: fontSize)
    }
    
    func configureEmoji() {
        [goToSettingsEmojiLabel, tapGeneralEmojiLabel, findAndTapKeyboardsEmojiLabel,
         tapAddNewKeyboardEmojiLabel, tapChemKeyboardEmojiLabel].forEach { emojiLabel in
            switch type {
            case .iPhoneSE, .iPhone7, .iPhone8Plus, .iPhoneX:
                emojiLabel?.font = UIFont(name: "AppleColorEmoji", size: 23)
            case .iPad:
                emojiLabel?.font = UIFont(name: "AppleColorEmoji", size: 45)
            case .iPadWide:
                emojiLabel?.font = UIFont(name: "AppleColorEmoji", size: 95)
            case .iPadHorizontal:
                emojiLabel?.font = UIFont(name: "AppleColorEmoji", size: 65)
            }
        }
    }
    
}

private extension InstructionsViewController {
    
    private func alignLabelsToEmoji(padding: CGFloat, align: Align, width: CGFloat, height: CGFloat) {
        goToSettingsLabel.align(align, relativeTo: goToSettingsEmojiLabel,
                                padding: padding, width: width, height: height)
        tapGeneralLabel.align(align, relativeTo: tapGeneralEmojiLabel,
                              padding: padding, width: width, height: height)
        findAndTapKeyboardsLabel.align(align, relativeTo: findAndTapKeyboardsEmojiLabel,
                                       padding: padding, width: width, height: height)
        tapAddNewKeyboardLabel.align(align, relativeTo: tapAddNewKeyboardEmojiLabel,
                                     padding: padding, width: width, height: height)
        tapChemKeyboardLabel.align(align, relativeTo: tapChemKeyboardEmojiLabel,
                                   padding: padding, width: width, height: height)
    }
    
    }
    
}
