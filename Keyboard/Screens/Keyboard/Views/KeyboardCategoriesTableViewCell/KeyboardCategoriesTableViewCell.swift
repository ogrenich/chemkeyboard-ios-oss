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
import Device
import Neon

@IBDesignable
class KeyboardCategoriesTableViewCell: UITableViewCell {
    
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                             collectionViewLayout:
                                                                             UICollectionViewFlowLayout())
    
    
    fileprivate weak var needsScrollElementsCollectionViewToCategoryAt: PublishSubject<Int>!
    fileprivate weak var needsPlayInputClick: PublishSubject<Void>!
    
    
    fileprivate var bag = DisposeBag()
    fileprivate var viewModel: KeyboardCategoriesTableViewCellModel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.fillSuperview()
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
        
        setupUI()
        
        configureCollectionView()
        
        bindSelf()
        bindToViewModel()
        bindViewModel()
        
        return self
    }
    
}

private extension KeyboardCategoriesTableViewCell {
    
    func setupUI() {
        backgroundColor = .clear
    }
    
}

private extension KeyboardCategoriesTableViewCell {
    
    func configureCollectionView() {
        if collectionView.superview == nil {
            addSubview(collectionView)
        }
        
        collectionView.register(KeyboardCategoriesCollectionViewCell.self)
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        collectionView.delegate = self
        
        layout.scrollDirection = .horizontal
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.alwaysBounceHorizontal = true
        
        collectionView.backgroundColor = .clear
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = CGSize(width: 100, height: 36)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInset: CGFloat = 6 + (Device.isPad() && (UIScreen.main.bounds.width > UIScreen.main.bounds.height) ?
            130 : 0)
        
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }

}
