//
//  MainViewController.swift
//  ChemKeyboard
//
//  Created by Andrey Ogrenich on 25/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController, Storyboardable {
    
    @IBOutlet weak var infoButton: Button!
    @IBOutlet weak var formulaTextField: TextField!
    @IBOutlet weak var clearTextButton: Button!
    @IBOutlet weak var copyToClipboardButton: Button!
    @IBOutlet weak var versionLabel: UILabel!
    
    
    fileprivate let bag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindSelf()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        formulaTextField.becomeFirstResponder()
    }

}

private extension MainViewController {
    
    func bindSelf() {
        infoButton.rx.tap
            .bind { [weak self] in
                self?.performSegue(withIdentifier: "Instructions", sender: nil)
            }
            .disposed(by: bag)
        
        formulaTextField.rx.text
            .map { $0 == nil || $0?.count == 0 }
            .bind { [weak self] in
                guard let `self` = self else {
                    return
                }
                
                self.clearTextButton.isHidden = $0
                self.copyToClipboardButton.isEnabled = !$0
            }
            .disposed(by: bag)
        
        clearTextButton.rx.tap
            .bind { [weak self] in
                guard let `self` = self else {
                    return
                }
                
                self.formulaTextField.text = nil
                self.clearTextButton.isHidden = true
                self.copyToClipboardButton.isEnabled = false
            }
            .disposed(by: bag)
        
        copyToClipboardButton.rx.tap
            .withLatestFrom(formulaTextField.rx.text)
            .bind { UIPasteboard.general.string = $0 }
            .disposed(by: bag)
    }
    
}
