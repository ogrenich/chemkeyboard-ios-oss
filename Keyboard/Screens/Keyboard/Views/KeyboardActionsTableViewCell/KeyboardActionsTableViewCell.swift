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
import Device
import Neon

@IBDesignable
class KeyboardActionsTableViewCell: UITableViewCell {
    
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                             collectionViewLayout:
                                                                             UICollectionViewFlowLayout())    
    
    fileprivate weak var needsPlayInputClick: PublishSubject<Void>!
    
    
    fileprivate var bag = DisposeBag()
    fileprivate var viewModel: KeyboardActionsTableViewCellModel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.fillSuperview()
    }
        
}

extension KeyboardActionsTableViewCell {
    
    @discardableResult
    func configure(with viewModel: KeyboardActionsTableViewCellModel,
                   _ needsPlayInputClick: PublishSubject<Void>) -> KeyboardActionsTableViewCell {
        self.viewModel = viewModel
        self.needsPlayInputClick = needsPlayInputClick
        
        setupUI()
        
        configureCollectionView()
        
        bindSelf()
        bindToViewModel()
        bindViewModel()
        
        return self
    }
    
}

private extension KeyboardActionsTableViewCell {
    
    func setupUI() {
        backgroundColor = .clear
    }
    
}

private extension KeyboardActionsTableViewCell {
    
    func configureCollectionView() {
        if collectionView.superview == nil {
            addSubview(collectionView)
        }
        
        collectionView.register(KeyboardActionsCollectionViewCell.self)
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        collectionView.delegate = self
        
        layout.scrollDirection = .horizontal
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = false
        collectionView.bounces = false
        collectionView.bouncesZoom = false
        
        collectionView.backgroundColor = .clear
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 6
    }
        
}

private extension KeyboardActionsTableViewCell {
    
    func bindSelf() {
        collectionView.rx.itemHighlighted
            .map { _ in }
            .bind(to: needsPlayInputClick)
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
                self?.collectionView.selectItem(at: indexPath,
                                                animated: true,
                                                scrollPosition: .centeredHorizontally)
                
                self?.collectionView.reloadData()
            })
            .disposed(by: bag)
    }
    
}

extension KeyboardActionsTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInset: CGFloat = 8 + (Device.isPad() && (UIScreen.main.bounds.width > UIScreen.main.bounds.height) ?
            180 : 0)
        
        return UIEdgeInsets(top: 6, left: sideInset, bottom: 6, right: sideInset)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        let horizontalInsets: CGFloat = 16 + (Device.isPad() &&
            (UIScreen.main.bounds.width > UIScreen.main.bounds.height) ? 360 : 0)
        let width = (collectionView.frame.size.width - 5 * layout.minimumLineSpacing - horizontalInsets) / 6
        return CGSize(width: width, height: 28)
    }
    
}
