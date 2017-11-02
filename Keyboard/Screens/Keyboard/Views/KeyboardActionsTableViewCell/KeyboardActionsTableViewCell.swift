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

@IBDesignable
class KeyboardActionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    fileprivate weak var needsReactToDeleteButtonTouchEvent: PublishSubject<Void>!
    fileprivate weak var needsPlayInputClick: PublishSubject<Void>!
    
    
    fileprivate var bag = DisposeBag()
    fileprivate var viewModel: KeyboardActionsTableViewCellModel!
    
    fileprivate weak var timer: Timer?
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
    
    deinit {
        invalidateTimer()
    }
    
}

extension KeyboardActionsTableViewCell {
    
    @discardableResult
    func configure(with viewModel: KeyboardActionsTableViewCellModel,
                   needsReactToDeleteButtonTouchEvent: PublishSubject<Void>,
                   _ needsPlayInputClick: PublishSubject<Void>) -> KeyboardActionsTableViewCell {
        self.viewModel = viewModel
        self.needsReactToDeleteButtonTouchEvent = needsReactToDeleteButtonTouchEvent
        self.needsPlayInputClick = needsPlayInputClick
        
        configureCollectionView()
        
        addGestureRecognizersOnDeleteButton()
        
        bindSelf()
        bindToViewModel()
        bindViewModel()
        
        return self
    }
    
}

private extension KeyboardActionsTableViewCell {
    
    func configureCollectionView() {
        collectionView.register(KeyboardActionsCollectionViewCell.self)
    }
    
}

private extension KeyboardActionsTableViewCell {
    
    func bindSelf() {
        switchButton.rx.tap
            .bind(to: needsPlayInputClick)
            .disposed(by: bag)
        
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
            130 : 0)
        
        return UIEdgeInsets(top: 6, left: sideInset, bottom: 6, right: sideInset)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        let horizontalInsets: CGFloat = 16 + (Device.isPad() &&
            (UIScreen.main.bounds.width > UIScreen.main.bounds.height) ? 260 : 0)
        let width = (collectionView.frame.size.width - 5 * layout.minimumInteritemSpacing - horizontalInsets) / 6
        
        return CGSize(width: width, height: 44)
    }
    
}

private extension KeyboardActionsTableViewCell {
    
    func setUpTimer(with selector: Selector) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                     selector: selector,
                                     userInfo: nil, repeats: true)
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}

extension KeyboardActionsTableViewCell {
    
    func addGestureRecognizersOnDeleteButton() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(handleSimpleDeleteEvent))
        
        let longPress = UILongPressGestureRecognizer(target: self,
                                                     action: #selector(handleLongPressOnDeleteButton(_:)))
       
        deleteButton.addGestureRecognizer(tap)
        deleteButton.addGestureRecognizer(longPress)
    }
    
    @objc func handleSimpleDeleteEvent() {
        needsReactToDeleteButtonTouchEvent.onNext(())
        needsPlayInputClick.onNext(())
    }
    
    @objc func handleLongPressOnDeleteButton(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            setUpTimer(with: #selector(handleSimpleDeleteEvent))
        case .ended, .cancelled, .failed:
            invalidateTimer()
        default:
            break
        }
    }
    
}

extension KeyboardActionsTableViewCell {
    
    func willRotate() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else {
                return
            }
        
            self.collectionView.reloadData()
            self.collectionView.setNeedsLayout()
            self.collectionView.layoutIfNeeded()
        }
    }
    
}
