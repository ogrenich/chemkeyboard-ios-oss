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
    
    fileprivate var bag = DisposeBag()
    fileprivate let viewModel = KeyboardViewModel()
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
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
        tableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
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
            return cell.configure(with: cellModel)
        case .elements:
            let cell: KeyboardElementsTableViewCell = tableView.dequeueReusableCell()
            let cellModel = KeyboardElementsTableViewCellModel.init(with: viewModel.categories,
                                                                    selectedCategory: viewModel.selectedCategory)
            return cell.configure(with: cellModel)
        case .symbols:
            let cell: KeyboardSymbolsTableViewCell = tableView.dequeueReusableCell()
            let cellModel = KeyboardSymbolsTableViewCellModel.init(with: viewModel.selectedSymbolGroup)
            return cell.configure(with: cellModel)
        case .actions:
            let cell: KeyboardActionsTableViewCell = tableView.dequeueReusableCell()
            let cellModel = KeyboardActionsTableViewCellModel.init(with: viewModel.symbolGroups,
                                                                   selectedSymbolGroup: viewModel.selectedSymbolGroup)
            return cell.configure(with: cellModel)
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
            return 52
        case .actions:
            return 56
        }
    }
    
}
