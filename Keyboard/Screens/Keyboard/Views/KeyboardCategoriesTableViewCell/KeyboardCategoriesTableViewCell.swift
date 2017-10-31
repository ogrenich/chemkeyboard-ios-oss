//
//  KeyboardCategoriesTableViewCell.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
class KeyboardCategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    fileprivate weak var needsScrollElementsCollectionViewToCategoryAt: PublishSubject<Int>!
    fileprivate weak var needsPlayInputClick: PublishSubject<Void>!
    
    
    fileprivate var bag = DisposeBag()
    fileprivate var viewModel: KeyboardCategoriesTableViewCellModel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
    
}

extension KeyboardCategoriesTableViewCell {
    
    @discardableResult
    func configure(with viewModel: KeyboardCategoriesTableViewCellModel,
                   _ needsScrollElementsCollectionViewToCategoryAt: PublishSubject<Int>,
                   _ needsPlayInputClick: PublishSubject<Void>) -> KeyboardCategoriesTableViewCell {
        self.viewModel = viewModel
        self.needsScrollElementsCollectionViewToCategoryAt = needsScrollElementsCollectionViewToCategoryAt
        self.needsPlayInputClick = needsPlayInputClick
        
        configureCollectionView()
        
        bindSelf()
        bindToViewModel()
        bindViewModel()
        
        return self
    }
    
}

private extension KeyboardCategoriesTableViewCell {
    
    func configureCollectionView() {
        collectionView.register(KeyboardCategoriesCollectionViewCell.self)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        }
    }
    
}

private extension KeyboardCategoriesTableViewCell {
    
    func bindSelf() {
        collectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: needsScrollElementsCollectionViewToCategoryAt)
            .disposed(by: bag)
        
        collectionView.rx.itemHighlighted
            .map { _ in }
            .bind(to: needsPlayInputClick)
            .disposed(by: bag)
    }
    
    func bindToViewModel() {
        collectionView.rx.modelSelected(ElementCategory.self).asDriver()
            .drive(viewModel.selectedCategory)
            .disposed(by: bag)
    }
    
    func bindViewModel() {
        viewModel.categories.asDriver()
            .drive(collectionView.rx.items) { [weak self] (collectionView, item, category) in
                let cell: KeyboardCategoriesCollectionViewCell = collectionView.dequeueReusableCell(for: IndexPath(item: item, section: 0))
                return cell.configure(with: category, selected: category == self?.viewModel.selectedCategory.value)
            }
            .disposed(by: bag)
        
        viewModel.selectedCategory.asDriver()
            .filter { $0 != nil }
            .map { $0! }
            .withLatestFrom(viewModel.categories.asDriver()) { ($0, $1) }
            .map { $1.index(of: $0) }
            .filter { $0 != nil }
            .map { $0! }
            .map { IndexPath(item: $0, section: 0) }
            .drive(onNext: { [weak self] indexPath in
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else {
                        return
                    }
                    
                    self.collectionView.scrollToItem(at: indexPath,
                                                     at: .centeredHorizontally,
                                                     animated: true)
                    
                    self.collectionView.selectItem(at: indexPath,
                                                   animated: true,
                                                   scrollPosition: .centeredHorizontally)
                }
            })
            .disposed(by: bag)
    }
    
}

extension KeyboardCategoriesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 36)
    }
    
}
