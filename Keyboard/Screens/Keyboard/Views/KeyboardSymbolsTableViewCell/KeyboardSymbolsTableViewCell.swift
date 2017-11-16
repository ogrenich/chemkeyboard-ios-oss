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
import Device
import Neon

@IBDesignable
class KeyboardSymbolsTableViewCell: UITableViewCell {
    
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                             collectionViewLayout:
                                                                             UICollectionViewFlowLayout())
    
    
    fileprivate weak var needsReactToSimpleButtonTouchEvent: PublishSubject<Symbol?>!
    fileprivate weak var needsPlayInputClick: PublishSubject<Void>!
    
    
    let cellTouchDown = PublishSubject<KeyboardSymbolsCollectionViewCell>()
    let cellTouchUp = PublishSubject<KeyboardSymbolsCollectionViewCell>()
    let cellDrag = PublishSubject<KeyboardSymbolsCollectionViewCell>()
    
    
    fileprivate var bag = DisposeBag()
    fileprivate var viewModel: KeyboardSymbolsTableViewCellModel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.fillSuperview()
    }
    
}

extension KeyboardSymbolsTableViewCell {
    
    @discardableResult
    func configure(with viewModel: KeyboardSymbolsTableViewCellModel,
                   needsReactToSimpleButtonTouchEvent: PublishSubject<Symbol?>,
                   _ needsPlayInputClick: PublishSubject<Void>) -> KeyboardSymbolsTableViewCell {
        self.viewModel = viewModel
        self.needsReactToSimpleButtonTouchEvent = needsReactToSimpleButtonTouchEvent
        self.needsPlayInputClick = needsPlayInputClick
        
        setupUI()
        
        configureCollectionView()
        
        bindSelf()
        bindViewModel()
        
        return self
    }
    
}

private extension KeyboardSymbolsTableViewCell {
    
    func setupUI() {
        backgroundColor = .clear
    }
    
}

private extension KeyboardSymbolsTableViewCell {
    
    func configureCollectionView() {
        if collectionView.superview == nil {
            addSubview(collectionView)
        }
        
        collectionView.register(KeyboardSymbolsCollectionViewCell.self)
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        collectionView.delegate = self
        
        layout.scrollDirection = .vertical
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = false
        collectionView.bounces = false
        collectionView.bouncesZoom = false
        
        collectionView.backgroundColor = .clear
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
    }
    
}

private extension KeyboardSymbolsTableViewCell {
    
    func bindSelf() {
        cellTouchDown
            .map { _ in }
            .bind(to: needsPlayInputClick)
            .disposed(by: bag)
        
        cellTouchDown
            .bind { [weak self] cell in
                guard let `self` = self else {
                    return
                }
                
                let frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y + 36 + 156,
                                   width: cell.frame.width, height: cell.frame.height)
                if let indexPath = self.collectionView.indexPath(for: cell) {
                    if let symbol = self.viewModel.selectedSymbolGroup?.value?.symbols[indexPath.item] {
                        if symbol.topIndex != nil && symbol.bottomIndex != nil {
                            PopUp.instance.show(symbol: symbol, at: frame, style: .extended)
                        } else {
                            PopUp.instance.show(symbol: symbol, at: frame, style: .simple)
                        }
                    }
                }
            }
            .disposed(by: bag)
        
        cellDrag
            .bind { cell in
                if let pointOfTouch = cell.pointOfTouch {
                    let pointInInputView = cell.convert(pointOfTouch, to: PopUp.instance.keyboardView)
                    PopUp.instance.select(at: pointInInputView)
                }
            }
            .disposed(by: bag)
        
        cellTouchUp
            .bind { _ in
                PopUp.instance.hide()
            }
            .disposed(by: bag)
        
        cellTouchUp
            .map { $0.chosenSymbol }
            .bind(to: needsReactToSimpleButtonTouchEvent)
            .disposed(by: bag)
    }
    
    func bindViewModel() {
        viewModel.selectedSymbolGroup.asDriver()
            .filter { $0 != nil }
            .map { $0! }
            .map { Array($0.symbols) }
            .drive(collectionView.rx.items) { [weak self] (collectionView, item, symbol) in
                let cell: KeyboardSymbolsCollectionViewCell = collectionView.dequeueReusableCell(for: IndexPath(item: item, section: 0))
                
                guard
                    let `self` = self,
                    let selectedSymbolGroup = self.viewModel.selectedSymbolGroup.value
                else {
                    return cell.configure(with: symbol, cellTouchDown: nil, cellTouchUp: nil, cellDrag: nil)
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
                
                if item == numberOfSymbols - numberOfSymbolsInLine && selectedSymbolGroup.name != "Digits" {
                    corners.insert(.bottomLeft)
                }
                
                if item == numberOfSymbols - 1 && selectedSymbolGroup.name != "Greek" {
                    corners.insert(.bottomRight)
                }
                
                return cell.configure(with: symbol, corners: corners, cellTouchDown: self.cellTouchDown,
                                      cellTouchUp: self.cellTouchUp, cellDrag: self.cellDrag)
            }
            .disposed(by: bag)
    }
    
}

extension KeyboardSymbolsTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInset: CGFloat = 8 + (Device.isPad() && (UIScreen.main.bounds.width > UIScreen.main.bounds.height) ? 136 : 0)
        
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionsInsets: CGFloat = 16 + (Device.isPad() &&
            (UIScreen.main.bounds.width > UIScreen.main.bounds.height) ? 272 : 0)
        let numberOfSymbolsInLine = viewModel.selectedSymbolGroup.value?.numberOfSymbolsInLine.value ?? 10
        
        return CGSize(width: (collectionView.frame.size.width - sectionsInsets) /
            CGFloat(numberOfSymbolsInLine), height: 44)
    }
    
}
