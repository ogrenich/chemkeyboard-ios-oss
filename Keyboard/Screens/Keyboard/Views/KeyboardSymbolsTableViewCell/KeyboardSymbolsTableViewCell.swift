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

@IBDesignable
class KeyboardSymbolsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    fileprivate weak var needsReactToSimpleButtonTouchEvent: PublishSubject<Symbol?>!
    
    
    let cellTouchDown = PublishSubject<KeyboardSymbolsCollectionViewCell>()
    let cellTouchUp = PublishSubject<KeyboardSymbolsCollectionViewCell>()
    let cellDrag = PublishSubject<KeyboardSymbolsCollectionViewCell>()
    
    
    fileprivate var bag = DisposeBag()
    fileprivate var viewModel: KeyboardSymbolsTableViewCellModel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
    
}

extension KeyboardSymbolsTableViewCell {
    
    @discardableResult
    func configure(with viewModel: KeyboardSymbolsTableViewCellModel,
                   needsReactToSimpleButtonTouchEvent: PublishSubject<Symbol?>) -> KeyboardSymbolsTableViewCell {
        self.viewModel = viewModel
        self.needsReactToSimpleButtonTouchEvent = needsReactToSimpleButtonTouchEvent
        
        configureCollectionView()
        
        bindSelf()
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
    
    func bindSelf() {
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
                
                if item == numberOfSymbols - numberOfSymbolsInLine {
                    corners.insert(.bottomLeft)
                }
                
                if item == numberOfSymbols - 1 {
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
        
        return UIEdgeInsets(top: 8, left: sideInset, bottom: 0, right: sideInset)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        let sectionsInsets: CGFloat = 16 + (Device.isPad() &&
            (UIScreen.main.bounds.width > UIScreen.main.bounds.height) ? 272 : 0)
        let numberOfSymbolsInLine = viewModel.selectedSymbolGroup.value?.numberOfSymbolsInLine.value ?? 10
        let interitemsSpacing = layout.minimumInteritemSpacing * CGFloat(numberOfSymbolsInLine - 1)
        
        return CGSize(width: (collectionView.frame.size.width - sectionsInsets - interitemsSpacing) / CGFloat(numberOfSymbolsInLine), height: 44)
    }
    
}
