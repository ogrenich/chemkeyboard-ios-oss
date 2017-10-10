//
//  KeyboardActionsTableViewCell.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
class KeyboardActionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var deleteButton: UIButton!
    
    fileprivate weak var needsReactToSwitchButtonTouchEvent: PublishSubject<Void>!
    fileprivate weak var needsReactToDeleteButtonTouchEvent: PublishSubject<Void>!
    
    fileprivate var bag = DisposeBag()
    fileprivate var viewModel: KeyboardActionsTableViewCellModel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
}

extension KeyboardActionsTableViewCell {
    
    @discardableResult
    func configure(with viewModel: KeyboardActionsTableViewCellModel,
                   needsReactToSwitchButtonTouchEvent: PublishSubject<Void>,
                   needsReactToDeleteButtonTouchEvent: PublishSubject<Void>) -> KeyboardActionsTableViewCell {
        self.viewModel = viewModel
        self.needsReactToSwitchButtonTouchEvent = needsReactToSwitchButtonTouchEvent
        self.needsReactToDeleteButtonTouchEvent = needsReactToDeleteButtonTouchEvent
        
        configureLeftAndRightViews()
        configureCollectionView()
        
        bindSelf()
        bindToViewModel()
        bindViewModel()
        
        return self
    }
    
}

private extension KeyboardActionsTableViewCell {
    
    func configureLeftAndRightViews() {
        leftView.roundCorners(corners: .topRight, radius: 8)
        rightView.roundCorners(corners: .topLeft, radius: 8)
    }
    
    func configureCollectionView() {
        collectionView.register(KeyboardActionsCollectionViewCell.self)
    }
    
}

private extension KeyboardActionsTableViewCell {
    
    func bindSelf() {
        switchButton.rx.tap
            .bind(to: needsReactToSwitchButtonTouchEvent)
            .disposed(by: bag)
        
        deleteButton.rx.tap
            .bind(to: needsReactToDeleteButtonTouchEvent)
            .disposed(by: bag)
    }
    
    func bindToViewModel() {
        collectionView.rx.modelSelected(SymbolGroup.self)
            .bind(to: viewModel.selectedSymbolGroup)
            .disposed(by: bag)
    }
    
    func bindViewModel() {
        viewModel.symbolGroups.asDriver()
            .drive(collectionView.rx.items) { [weak self] (collectionView, item, symbolGroup) in
                let cell: KeyboardActionsCollectionViewCell = collectionView.dequeueReusableCell(for: IndexPath(item: item, section: 0))
                return cell.configure(with: symbolGroup,
                                      selected: symbolGroup == self?.viewModel.selectedSymbolGroup.value)
            }
            .disposed(by: bag)
        
        viewModel.selectedSymbolGroup.asDriver()
            .filter { $0 != nil }
            .map { $0! }
            .withLatestFrom(viewModel.symbolGroups.asDriver()) { ($0, $1) }
            .map { $1.index(of: $0) }
            .filter { $0 != nil }
            .map { $0! }
            .map { IndexPath(item: $0, section: 0) }
            .drive(onNext: { [weak self] indexPath in
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else {
                        return
                    }
                    
                    if let cell = self.collectionView.cellForItem(at: indexPath) {
                        self.leftViewWidthConstraint.constant = cell.frame.origin.x
                        self.rightViewWidthConstraint.constant = self.collectionView.frame.width - cell.frame.origin.x - cell.frame.width
                        self.setNeedsLayout()
                        self.layoutIfNeeded()
                    }
                    
                    self.collectionView.selectItem(at: indexPath,
                                                   animated: true,
                                                   scrollPosition: .centeredHorizontally)
                    self.collectionView.reloadData()
                }
            })
            .disposed(by: bag)
    }
    
}

extension KeyboardActionsTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        let width = (collectionView.frame.size.width - 5 * layout.minimumInteritemSpacing -
                    layout.sectionInset.left - layout.sectionInset.right) / 6
        return CGSize(width: width, height: 44)
    }
    
}
