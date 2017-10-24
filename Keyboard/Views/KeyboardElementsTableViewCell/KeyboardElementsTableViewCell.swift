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
    fileprivate weak var needsScrollElementsCollectionViewToCategoryAt: PublishSubject<Int>!
    
    let cellTouchDown = PublishSubject<KeyboardElementsCollectionViewCell>()
    let cellTouchUp = PublishSubject<KeyboardElementsCollectionViewCell>()
    let cellTouchLong = PublishSubject<KeyboardElementsCollectionViewCell>()
    
    fileprivate var bag = DisposeBag()
    fileprivate var viewModel: KeyboardElementsTableViewCellModel!
    
    fileprivate var userIsScrolling: Bool = false

    var currentSection: RxSwift.Observable<Int> {
        return collectionView.rx.contentOffset
            .flatMap { [weak self] contentOffset -> RxSwift.Observable<Int> in
                guard
                    let `self` = self,
                    self.userIsScrolling
                else {
                    return Observable.empty()
                }
                
                var offsetToCurrentSection = contentOffset.x + self.collectionView.contentInset.left
                var section = -1
                
                while offsetToCurrentSection > 0 {
                    section += 1
                    offsetToCurrentSection -= self.widthOfCollectionViewSection(at: section)
                }
                
                section = section < 0 ? 0 : section
                
                return Observable.just(section)
            }
            .distinctUntilChanged()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
}

extension KeyboardElementsTableViewCell {
    
    @discardableResult
    func configure(with viewModel: KeyboardElementsTableViewCellModel,
                   needsReactToSimpleButtonTouchEvent: PublishSubject<Symbol?>,
                   _ needsScrollElementsCollectionViewToCategoryAt: PublishSubject<Int>) -> KeyboardElementsTableViewCell {
        self.viewModel = viewModel
        self.needsReactToSimpleButtonTouchEvent = needsReactToSimpleButtonTouchEvent
        self.needsScrollElementsCollectionViewToCategoryAt = needsScrollElementsCollectionViewToCategoryAt
        
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
        collectionView.rx.willBeginDragging
            .bind { [weak self] in
                self?.userIsScrolling = true
            }
            .disposed(by: bag)
        
        collectionView.rx.didEndDecelerating
            .bind { [weak self] in
                self?.userIsScrolling = false
            }
            .disposed(by: bag)

        collectionView.rx.willEndDragging
            .bind { [weak self] in
                if $0.velocity == .zero {
                    self?.userIsScrolling = false
                }
            }
            .disposed(by: bag)
        
        cellTouchDown
            .bind { [weak self] cell in
                guard let `self` = self else {
                    return
                }

                let frame = CGRect(x: cell.frame.origin.x - self.collectionView.contentOffset.x,
                                   y: cell.frame.origin.y + 36,
                                   width: cell.frame.width, height: cell.frame.height)
                if let indexPath = self.collectionView.indexPath(for: cell) {
                    let element = self.viewModel.categories.value[indexPath.section].elements[indexPath.item]
                    PopUp.instance.show(element: element, at: frame, style: .simple)
                }
            }
            .disposed(by: bag)
        
        cellTouchLong
            .bind { [weak self] cell in
                guard let `self` = self else {
                    return
                }
                
                let frame = CGRect(x: cell.frame.origin.x - self.collectionView.contentOffset.x,
                                   y: cell.frame.origin.y + 36,
                                   width: cell.frame.width, height: cell.frame.height)
                if let indexPath = self.collectionView.indexPath(for: cell) {
                    let element = self.viewModel.categories.value[indexPath.section].elements[indexPath.item]
                    PopUp.instance.show(element: element, at: frame, style: .extended)
                }
            }
            .disposed(by: bag)

        cellTouchUp
            .bind { _ in
                PopUp.instance.hide()
            }
            .disposed(by: bag)
        
        cellTouchUp
            .map { [weak self] in self?.collectionView.indexPath(for: $0) }
            .filter { $0 != nil }
            .map { $0! }
            .withLatestFrom(viewModel.categories.asObservable()) { ($0, $1) }
            .map { $1[$0.section].elements[$0.item].symbol }
            .bind(to: needsReactToSimpleButtonTouchEvent)
            .disposed(by: bag)
    }
    
    func bindToViewModel() {
        currentSection
            .withLatestFrom(viewModel.categories.asObservable()) { $1[$0] }
            .bind(to: viewModel.selectedCategory)
            .disposed(by: bag)
    }
    
    func bindViewModel() {
        needsScrollElementsCollectionViewToCategoryAt
            .bind { [weak self] in
                guard let `self` = self else {
                    return
                }
                
                var offset: CGFloat = 0
                
                (0..<$0).forEach { [weak self] section in
                    offset += self?.widthOfCollectionViewSection(at: section) ?? 0
                }
                
                let maxContentOffset = self.collectionView.contentSize.width - self.collectionView.frame.width
                offset = min(offset, maxContentOffset)
                self.collectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
            }
            .disposed(by: bag)
    }
    
}

private extension KeyboardElementsTableViewCell {
    
    func widthOfCollectionViewSection(at section: Int) -> CGFloat {
        let numberOfColumns = (CGFloat(viewModel.categories.value[section].elements.count) / 3).rounded(.up)
        return numberOfColumns * 66
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
        return cell.configure(with: element, cellTouchDown: cellTouchDown,
                              cellTouchUp: cellTouchUp, cellTouchLong: cellTouchLong)
    }
    
}
