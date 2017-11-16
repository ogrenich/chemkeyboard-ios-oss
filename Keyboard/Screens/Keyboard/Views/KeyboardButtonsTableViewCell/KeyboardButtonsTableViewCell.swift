//
//  KeyboardButtonsTableViewCell.swift
//  Keyboard
//
//  Created by Maria Dagaeva on 16.11.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class KeyboardButtonsTableViewCell: UITableViewCell {
    
    lazy var switchButton: UIButton = UIButton()
    fileprivate lazy var spaceButton: UIButton = UIButton()
    fileprivate lazy var returnButton: UIButton = UIButton()
    fileprivate lazy var deleteButton: UIButton = UIButton()
    
    fileprivate lazy var spaceSymbol: Symbol = Symbol()
    fileprivate lazy var returnSymbol: Symbol = Symbol()
    
    
    fileprivate weak var needsReactToSimpleButtonTouchEvent: PublishSubject<Symbol?>!
    fileprivate weak var needsReactToDeleteButtonTouchEvent: PublishSubject<Void>!
    fileprivate weak var needsPlayInputClick: PublishSubject<Void>!
    
    fileprivate var bag = DisposeBag()

    
    fileprivate var subviewsHierarchyHasBeenConfigured: Bool = false
    
    fileprivate weak var timer: Timer?

    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutFrames()
    }
    
    deinit {
        invalidateTimer()
    }

}

extension KeyboardButtonsTableViewCell {
    
    @discardableResult
    func configure(_ needsPlayInputClick: PublishSubject<Void>,
                   needsReactToDeleteButtonTouchEvent: PublishSubject<Void>,
                   needsReactToSimpleButtonTouchEvent: PublishSubject<Symbol?>) -> KeyboardButtonsTableViewCell {
        self.needsPlayInputClick = needsPlayInputClick
        self.needsReactToDeleteButtonTouchEvent = needsReactToDeleteButtonTouchEvent
        self.needsReactToSimpleButtonTouchEvent = needsReactToSimpleButtonTouchEvent
        
        configureButtons()
        
        if !subviewsHierarchyHasBeenConfigured {
            configureSubviewsHierarchy()
        }
        
        bindSelf()
        
        return self
    }

}

private extension KeyboardButtonsTableViewCell {
    
    func configureButtons() {
        switchButton.setImage(UIImage(named: "Switch"), for: .normal)
        switchButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 4, right: 0)
        
        spaceButton.setTitle("SPACE", for: .normal)
        spaceSymbol.value = " "
        
        returnButton.setTitle("RETURN", for: .normal)
        returnSymbol.value = "\n"
        
        [spaceButton, returnButton].forEach { button in
            button.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
            button.cornerRadius = 4
            button.titleLabel?.font = UIFont(name: "SFUIDisplay-Bold", size: 12)
            button.setTitleColor(.black, for: .normal)
            
            button.setTitle(button.titleLabel?.text, letterSpacing: 1.1)
        }
        
        deleteButton.setImage(UIImage(named: "Delete"), for: .normal)
        deleteButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 4)
        
        addGestureRecognizersOnDeleteButton()
    }
    
    func configureSubviewsHierarchy() {
        addSubview(switchButton)
        addSubview(spaceButton)
        addSubview(returnButton)
        addSubview(deleteButton)
        
        subviewsHierarchyHasBeenConfigured = true
    }
    
}

private extension KeyboardButtonsTableViewCell {
    
    func bindSelf() {
        switchButton.rx.tap
            .bind(to: needsPlayInputClick)
            .disposed(by: bag)
        
        spaceButton.rx.tap
            .bind(to: needsPlayInputClick)
            .disposed(by: bag)
        
        returnButton.rx.tap
            .bind(to: needsPlayInputClick)
            .disposed(by: bag)
        
        spaceButton.rx.tap
            .map { [weak self] in self?.spaceSymbol }
            .bind(to: needsReactToSimpleButtonTouchEvent)
            .disposed(by: bag)
        
        returnButton.rx.tap
            .map { [weak self] in self?.returnSymbol }
            .bind(to: needsReactToSimpleButtonTouchEvent)
            .disposed(by: bag)
    }
    
}

private extension KeyboardButtonsTableViewCell {
    
    func layoutFrames() {
        switchButton.fillSuperview(left: 0, right: width - 44, top: 0, bottom: 0)
        spaceButton.fillSuperview(left: 50, right: 47 + (width - 88) * 0.36, top: 0, bottom: 6)
        returnButton.fillSuperview(left: 47 + (width - 88) * 0.64, right: 50, top: 0, bottom: 6)
        deleteButton.fillSuperview(left: width - 44, right: 0, top: 0, bottom: 0)
    }
    
}

private extension KeyboardButtonsTableViewCell {

    func setUpTimer(with selector: Selector) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                     selector: selector,
                                     userInfo: nil, repeats: true)
    }

    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

}

extension KeyboardButtonsTableViewCell {

    func addGestureRecognizersOnDeleteButton() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(handleSimpleDeleteEvent))

        let longPress = UILongPressGestureRecognizer(target: self,
                                                     action: #selector(handleLongPressOnDeleteButton(_:)))

        deleteButton.addGestureRecognizer(tap)
        deleteButton.addGestureRecognizer(longPress)
    }

    @objc func handleSimpleDeleteEvent() {
        needsReactToDeleteButtonTouchEvent.onNext(())
        needsPlayInputClick.onNext(())
    }

    @objc func handleLongPressOnDeleteButton(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            setUpTimer(with: #selector(handleSimpleDeleteEvent))
        case .ended, .cancelled, .failed:
            invalidateTimer()
        default:
            break
        }
    }

}

