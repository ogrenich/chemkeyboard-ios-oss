//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 25/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AudioToolbox.AudioServices
import Device

private extension KeyboardViewController {

    enum Section: Int, Iteratable {
        case categories, elements, symbols, actions
    }

}

class KeyboardViewController: UIInputViewController {

    lazy var tableView = UITableView()
    var viewHeightConstraint: NSLayoutConstraint!

    let needsReactToDeleteButtonTouchEvent = PublishSubject<Void>()
    let needsReactToSimpleButtonTouchEvent = PublishSubject<Symbol?>()
    let needsScrollElementsCollectionViewToCategoryAt = PublishSubject<Int>()
    let needsPlayInputClick = PublishSubject<Void>()

    var mediumImpactFeedbackGenerator: UIImpactFeedbackGenerator? = nil

    fileprivate let bag = DisposeBag()
    fileprivate let viewModel = KeyboardViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        configurePopUp()
        configureTableView()

        bindSelf()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateUI()

        if UIDevice.current.hasHapticFeedback {
            mediumImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        }

        fetchData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        mediumImpactFeedbackGenerator = nil
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        DispatchQueue.main.async { [weak self] in
            UIView.performWithoutAnimation {
                self?.tableView.reloadData()
            }
        }
        
        updateHeightConstraint()
    }

}

private extension KeyboardViewController {

    func setupUI() {
        viewHeightConstraint = view.heightAnchor.constraint(equalToConstant: Device.isPad() ? 300 : 330)
    }

    func updateUI() {
        viewHeightConstraint.isActive = true
    }

    func fetchData() {
        viewModel.needsFetchData.onNext(())
    }

}

private extension KeyboardViewController {

    func configurePopUp() {
        PopUp.instance.keyboardView = view
    }

}

private extension KeyboardViewController {

    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.bounces = false
        tableView.bouncesZoom = false
        tableView.alwaysBounceHorizontal = false
        tableView.alwaysBounceVertical = false

        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        tableView
            .register(KeyboardCategoriesTableViewCell.self)
            .register(KeyboardElementsTableViewCell.self)
            .register(KeyboardSymbolsTableViewCell.self)
            .register(KeyboardActionsTableViewCell.self)
    }

}

private extension KeyboardViewController {

    func bindSelf() {
        needsReactToDeleteButtonTouchEvent
            .bind { [weak self] in
                self?.deleteLastSymbol()
            }
            .disposed(by: bag)

        needsReactToSimpleButtonTouchEvent
            .bind { [weak self] symbol in
                self?.textDocumentProxy.insertText(symbol?.value ?? "")
            }
            .disposed(by: bag)

        needsPlayInputClick
            .bind { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    UIDevice.current.playInputClick()
                    if UIDevice.current.hasHapticFeedback {
                        self?.mediumImpactFeedbackGenerator?.prepare()
                        self?.mediumImpactFeedbackGenerator?.impactOccurred()
                    } else if UIDevice.current.hasTapticEngine {
                        let peek = SystemSoundID(1519)
                        AudioServicesPlaySystemSound(peek)
                    }
                }
            }
            .disposed(by: bag)
    }

    func bindViewModel() {
        viewModel.categories.asDriver()
            .map { _ in }
            .drive(onNext: { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    UIView.performWithoutAnimation {
                        self?.tableView.reloadSections([Section.categories.rawValue,
                                                        Section.elements.rawValue],
                                                       with: .none)
                    }
                }
            })
            .disposed(by: bag)

        viewModel.symbolGroups.asDriver()
            .map { _ in }
            .drive(onNext: { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    UIView.performWithoutAnimation {
                        self?.tableView.reloadSections([Section.actions.rawValue,
                                                        Section.symbols.rawValue],
                                                       with: .none)
                    }
                }
            })
            .disposed(by: bag)

        viewModel.selectedSymbolGroup.asObservable()
            .bind { [weak self] _ in
                self?.updateHeightConstraint()
            }
            .disposed(by: bag)

        viewModel.selectedSymbolGroup.asDriver()
            .drive(onNext: { [weak self] _ in
                DispatchQueue.main.async { [weak self] in
                    UIView.performWithoutAnimation {
                        self?.tableView.reloadSections([Section.symbols.rawValue],
                                                       with: .none)
                    }
                }
            })
            .disposed(by: bag)
    }

}

private extension KeyboardViewController {
    
    func updateHeightConstraint() {
        let numberOfLines: CGFloat
        
        if let selectedSymbolGroup = viewModel.selectedSymbolGroup.value, let numberOfSymbolsInLine = selectedSymbolGroup.numberOfSymbolsInLine.value {
            numberOfLines = (CGFloat(selectedSymbolGroup.symbols.count) / CGFloat(numberOfSymbolsInLine)).rounded(.up)
        } else {
            numberOfLines = 0
        }
        
        let constant = (Device.isPad() ? 300 - 44 : 330 - 44) + numberOfLines * 44 -
            (UIScreen.main.bounds.height < UIScreen.main.bounds.width && !Device.isPad() ? 100 : 0)
        viewHeightConstraint.constant = constant
    }
    
}

extension KeyboardViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.cases().count
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        switch section {
        case .categories:
            let cell: KeyboardCategoriesTableViewCell = tableView.dequeueReusableCell()

            let cellModel = KeyboardCategoriesTableViewCellModel.init(with: viewModel.categories,
                                                                      selectedCategory: viewModel.selectedCategory)

            return cell.configure(with: cellModel,
                                  needsScrollElementsCollectionViewToCategoryAt,
                                  needsPlayInputClick)
        case .elements:
            let cell: KeyboardElementsTableViewCell = tableView.dequeueReusableCell()

            let cellModel = KeyboardElementsTableViewCellModel.init(with: viewModel.categories,
                                                                    selectedCategory: viewModel.selectedCategory)

            return cell.configure(with: cellModel,
                                  needsReactToSimpleButtonTouchEvent: needsReactToSimpleButtonTouchEvent,
                                  needsScrollElementsCollectionViewToCategoryAt, needsPlayInputClick)
        case .symbols:
            let cell: KeyboardSymbolsTableViewCell = tableView.dequeueReusableCell()
            let cellModel = KeyboardSymbolsTableViewCellModel.init(with: viewModel.selectedSymbolGroup)

            return cell.configure(with: cellModel,
                                  needsReactToSimpleButtonTouchEvent: needsReactToSimpleButtonTouchEvent,
                                  needsPlayInputClick)
        case .actions:
            let cell: KeyboardActionsTableViewCell = tableView.dequeueReusableCell()
            let cellModel = KeyboardActionsTableViewCellModel.init(with: viewModel.symbolGroups,
                                                                   selectedSymbolGroup: viewModel.selectedSymbolGroup)
            
            let configuredCell = cell.configure(with: cellModel,
                                                needsPlayInputClick,
                                                needsReactToDeleteButtonTouchEvent: needsReactToDeleteButtonTouchEvent,
                                                needsReactToSimpleButtonTouchEvent: needsReactToSimpleButtonTouchEvent)
            
            configuredCell.switchButton.addTarget(self,
                                                  action: #selector(handleInputModeList(from:with:)),
                                                  for: .allTouchEvents)
            configuredCell.returnButton.setTitle(returnKeyString, letterSpacing: 1.1)
            
            return configuredCell
        }
    }

}

extension KeyboardViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else {
            return CGFloat.leastNonzeroMagnitude
        }

        switch section {
        case .categories:
            return 36
        case .elements:
            if UIScreen.main.bounds.height < UIScreen.main.bounds.width && !Device.isPad() {
                return 60
            }
            return 160
        case .symbols:
            guard
                let selectedSymbolGroup = viewModel.selectedSymbolGroup.value,
                let numberOfSymbolsInLine = selectedSymbolGroup.numberOfSymbolsInLine.value
            else {
                return CGFloat.leastNonzeroMagnitude
            }

            let numberOfLines = (CGFloat(selectedSymbolGroup.symbols.count)
                / CGFloat(numberOfSymbolsInLine)).rounded(.up)

            return numberOfLines * 44
        case .actions:
            return Device.isPad() ? 60 : 90
        }
    }

}

extension KeyboardViewController {

    func deleteLastSymbol() {
        var lengthOfSymbol = 1

        if let context = textDocumentProxy.documentContextBeforeInput {
            let regex = try! NSRegularExpression(pattern: "([A-Z][a-z]*)")

            let matches = regex.matches(in: context,
                                        range: NSRange(location: 0,
                                                       length: context.count))

            if let last = matches.last,
                last.range.location + last.range.length == context.count {
                lengthOfSymbol = last.range.length
            }
        }

        (0..<lengthOfSymbol).forEach { [weak self] _ in
            self?.textDocumentProxy.deleteBackward()
        }
    }

}

extension UIInputView: UIInputViewAudioFeedback {

    public var enableInputClicksWhenVisible: Bool {
        return true
    }

}
