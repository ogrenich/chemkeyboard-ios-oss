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
    fileprivate var viewModel: KeyboardSymbolsTableViewCellModel!
    
    
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
            .drive(collectionView.rx.items) { [weak self] (collectionView, item, symbol) in
                let cell: KeyboardSymbolsCollectionViewCell = collectionView.dequeueReusableCell(for: IndexPath(item: item, section: 0))
                
                guard let selectedSymbolGroup = self?.viewModel.selectedSymbolGroup.value else {
                    return cell.configure(with: symbol)
                }
                
                let numberOfSymbols = selectedSymbolGroup.symbols.count
                let numberOfSymbolsInLine = selectedSymbolGroup.numberOfSymbolsInLine.value ?? 10
                
                var corners: UIRectCorner = []
                
                if item == 0 {
                    corners.insert(.topLeft)
                }
                
                if item == numberOfSymbolsInLine - 1 {
                    corners.insert(.topRight)
                }
                
                if item == numberOfSymbols - numberOfSymbolsInLine {
                    corners.insert(.bottomLeft)
                }
                
                if item == numberOfSymbols - 1 {
                    corners.insert(.bottomRight)
                }
                
                return cell.configure(with: symbol, corners: corners)
            }
            .disposed(by: bag)
    }
    
}

extension KeyboardSymbolsTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        let sectionsInsets = layout.sectionInset.left + layout.sectionInset.right
        let numberOfSymbolsInLine = viewModel.selectedSymbolGroup.value?.numberOfSymbolsInLine.value ?? 10
        let interitemsSpacing = layout.minimumInteritemSpacing * CGFloat(numberOfSymbolsInLine - 1)
        
        return CGSize(width: (collectionView.frame.size.width - sectionsInsets - interitemsSpacing) / CGFloat(numberOfSymbolsInLine), height: 44)
    }
    
}
