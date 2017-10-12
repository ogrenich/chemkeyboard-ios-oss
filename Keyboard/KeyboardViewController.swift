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

private extension KeyboardViewController {
    
    enum Section: Int, Iteratable {
        case categories, elements, symbols, actions
    }
    
}

class KeyboardViewController: UIInputViewController {
    
    lazy var tableView = UITableView()
    var tableViewHeightConstraint: NSLayoutConstraint!
    
    let needsReactToSwitchButtonTouchEvent = PublishSubject<Void>()
    let needsReactToDeleteButtonTouchEvent = PublishSubject<Void>()
    let needsReactToSimpleButtonTouchEvent = PublishSubject<Symbol?>()
    let needsScrollElementsCollectionViewToCategoryAt = PublishSubject<Int>()
    
    fileprivate var bag = DisposeBag()
    fileprivate let viewModel = KeyboardViewModel()
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        bindSelf()
        bindViewModel()
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
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 300)
        tableViewHeightConstraint.isActive = true
        
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
        needsReactToSwitchButtonTouchEvent
            .bind { [weak self] in
                self?.advanceToNextInputMode()
            }
            .disposed(by: bag)
        
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
    }
    
    func bindViewModel() {
        viewModel.selectedSymbolGroup.asDriver()
            .map {
                guard
                    let selectedSymbolGroup = $0,
                    let numberOfSymbolsInLine = selectedSymbolGroup.numberOfSymbolsInLine.value
                else {
                    return 300 - 52
                }

                let numberOfLines = (CGFloat(selectedSymbolGroup.symbols.count) / CGFloat(numberOfSymbolsInLine)).rounded(.up)
                return (300 - 52) + (numberOfLines * 44) + ((numberOfLines - 1) * 1) + 8
            }
            .drive(tableViewHeightConstraint.rx.constant)
            .disposed(by: bag)
        
        viewModel.selectedSymbolGroup.asDriver()
            .drive(onNext: { [weak self] _ in
                DispatchQueue.main.async { [weak self] in
                    UIView.performWithoutAnimation {
                        self?.tableView.reloadSections(IndexSet(integersIn: 2...2), with: .none)
                    }
                }
            })
            .disposed(by: bag)
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
                                  needsScrollElementsCollectionViewToCategoryAt)
        case .elements:
            let cell: KeyboardElementsTableViewCell = tableView.dequeueReusableCell()
            let cellModel = KeyboardElementsTableViewCellModel.init(with: viewModel.categories,
                                                                    selectedCategory: viewModel.selectedCategory)
            return cell.configure(with: cellModel,
                                  needsReactToSimpleButtonTouchEvent: needsReactToSimpleButtonTouchEvent,
                                  needsScrollElementsCollectionViewToCategoryAt)
        case .symbols:
            let cell: KeyboardSymbolsTableViewCell = tableView.dequeueReusableCell()
            let cellModel = KeyboardSymbolsTableViewCellModel.init(with: viewModel.selectedSymbolGroup)
            return cell.configure(with: cellModel,
                                  needsReactToSimpleButtonTouchEvent: needsReactToSimpleButtonTouchEvent)
        case .actions:
            let cell: KeyboardActionsTableViewCell = tableView.dequeueReusableCell()
            let cellModel = KeyboardActionsTableViewCellModel.init(with: viewModel.symbolGroups,
                                                                   selectedSymbolGroup: viewModel.selectedSymbolGroup)
            return cell.configure(with: cellModel,
                                  needsReactToSwitchButtonTouchEvent: needsReactToSwitchButtonTouchEvent,
                                  needsReactToDeleteButtonTouchEvent: needsReactToDeleteButtonTouchEvent)
        }
    }
    
}

extension KeyboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else {
            return CGFloat.leastNonzeroMagnitude
        }
        
        switch section {
        case .categories:
            return 36
        case .elements:
            return 156
        case .symbols:
            guard
                let selectedSymbolGroup = viewModel.selectedSymbolGroup.value,
                let numberOfSymbolsInLine = selectedSymbolGroup.numberOfSymbolsInLine.value
            else {
                return CGFloat.leastNonzeroMagnitude
            }
            
            let numberOfLines = (CGFloat(selectedSymbolGroup.symbols.count) / CGFloat(numberOfSymbolsInLine)).rounded(.up)
            return (numberOfLines * 44) + ((numberOfLines - 1) * 1) + 8
        case .actions:
            return 56
        }
    }
    
}

extension KeyboardViewController {
    
    func deleteLastSymbol() {
        var lengthOfSymbol = 1
        
        if let context = textDocumentProxy.documentContextBeforeInput {
            let pattern = "([A-Z][a-z]*)"
            let regex = try! NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: context, options: [],
                                        range: NSRange(location: 0,
                                                       length: context.characters.count))
            if let last = matches.last,
                last.range.location + last.range.length == context.characters.count {
                lengthOfSymbol = last.range.length
            }
        }
        
        (0..<lengthOfSymbol).forEach { [weak self] _ in
            self?.textDocumentProxy.deleteBackward()
        }
    }
    
}
