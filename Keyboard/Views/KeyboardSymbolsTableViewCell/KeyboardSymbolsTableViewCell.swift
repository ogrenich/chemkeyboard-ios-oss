//
//  KeyboardSymbolsTableViewCell.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
class KeyboardSymbolsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var bag = DisposeBag()
    fileprivate weak var viewModel: KeyboardSymbolsTableViewCellModel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
}

extension KeyboardSymbolsTableViewCell {
    
    @discardableResult
    func configure(with viewModel: KeyboardSymbolsTableViewCellModel) -> KeyboardSymbolsTableViewCell {
        self.viewModel = viewModel
        
        configureCollectionView()
        
        bindToViewModel()
        bindViewModel()
        
        return self
    }
    
}

private extension KeyboardSymbolsTableViewCell {
    
    func configureCollectionView() {
        collectionView.register(KeyboardSymbolsCollectionViewCell.self)
    }
    
}

private extension KeyboardSymbolsTableViewCell {
    
    func bindToViewModel() {
        
    }
    
    func bindViewModel() {
        viewModel.selectedSymbolGroup.asDriver()
            .filter { $0 != nil }
            .map { $0! }
            .map { Array($0.symbols) }
            .drive(collectionView.rx.items) { (collectionView, item, symbol) in
                let cell: KeyboardSymbolsCollectionViewCell = collectionView.dequeueReusableCell(for: IndexPath(item: item, section: 0))
                return cell.configure(with: symbol)
            }
            .disposed(by: bag)
    }
    
}
