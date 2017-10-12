//
//  KeyboardElementsTableViewCell.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
class KeyboardElementsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate weak var needsReactToSimpleButtonTouchEvent: PublishSubject<Symbol?>!
    fileprivate weak var needsScrollElementsCollectionViewToSelectedCategory: PublishSubject<Int>!
    
    fileprivate var bag = DisposeBag()
    fileprivate var viewModel: KeyboardElementsTableViewCellModel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
}

extension KeyboardElementsTableViewCell {
    
    @discardableResult
    func configure(with viewModel: KeyboardElementsTableViewCellModel,
                   needsReactToSimpleButtonTouchEvent: PublishSubject<Symbol?>,
                   needsScrollElementsCollectionViewToSelectedCategory: PublishSubject<Int>) -> KeyboardElementsTableViewCell {
        self.viewModel = viewModel
        self.needsReactToSimpleButtonTouchEvent = needsReactToSimpleButtonTouchEvent
        self.needsScrollElementsCollectionViewToSelectedCategory = needsScrollElementsCollectionViewToSelectedCategory
        
        configureCollectionView()
        
        bindSelf()
        bindToViewModel()
        bindViewModel()
        
        return self
    }
    
}

private extension KeyboardElementsTableViewCell {
    
    func configureCollectionView() {
        collectionView.register(KeyboardElementsCollectionViewCell.self)
    }
    
}

private extension KeyboardElementsTableViewCell {
    
    func bindSelf() {
        collectionView.rx.itemSelected
            .map { [weak self] in
                self?.viewModel.categories.value[$0.section].elements[$0.item].symbol
            }
            .bind(to: needsReactToSimpleButtonTouchEvent)
            .disposed(by: bag)
    }
    
    func bindToViewModel() {
        
    }
    
    func bindViewModel() {
        needsScrollElementsCollectionViewToSelectedCategory
            .bind { [weak self] in
                var offset: CGFloat = 0
                (0..<$0).forEach { [weak self] section in
                    offset += self?.widthOfCollectionViewSection(at: section) ?? 0
                }

                self?.collectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            }
            .disposed(by: bag)
    }
    
}

extension KeyboardElementsTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.value[section].elements.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.categories.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: KeyboardElementsCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let element = viewModel.categories.value[indexPath.section].elements.toArray()[indexPath.item]
        return cell.configure(with: element)
    }
    
}
