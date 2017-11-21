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
    
    lazy var switchButton: UIButton = UIButton()
    fileprivate lazy var spaceButton: UIButton = UIButton()
    lazy var returnButton: UIButton = UIButton()
    fileprivate lazy var deleteButton: UIButton = UIButton()
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                             collectionViewLayout:
                                                                             UICollectionViewFlowLayout())
    
    fileprivate lazy var spaceSymbol: Symbol = Symbol()
    fileprivate lazy var returnSymbol: Symbol = Symbol()

    
    fileprivate weak var needsReactToSimpleButtonTouchEvent: PublishSubject<Symbol?>!
    fileprivate weak var needsReactToDeleteButtonTouchEvent: PublishSubject<Void>!
    fileprivate weak var needsPlayInputClick: PublishSubject<Void>!
    
    
    fileprivate var bag = DisposeBag()
    fileprivate var viewModel: KeyboardActionsTableViewCellModel!
    
    
    fileprivate var subviewsHierarchyHasBeenConfigured: Bool = false
    
    fileprivate weak var timer: Timer?
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutFrames()
    }
    
    deinit {
        invalidateTimer()
    }

        
}

extension KeyboardActionsTableViewCell {
    
    @discardableResult
    func configure(with viewModel: KeyboardActionsTableViewCellModel,
                   _ needsPlayInputClick: PublishSubject<Void>,
                   needsReactToDeleteButtonTouchEvent: PublishSubject<Void>,
                   needsReactToSimpleButtonTouchEvent: PublishSubject<Symbol?>) -> KeyboardActionsTableViewCell {
        self.viewModel = viewModel
        self.needsPlayInputClick = needsPlayInputClick
        self.needsReactToDeleteButtonTouchEvent = needsReactToDeleteButtonTouchEvent
        self.needsReactToSimpleButtonTouchEvent = needsReactToSimpleButtonTouchEvent
        
        setupUI()
        
        configureButtons()
        
        configureCollectionView()
        
        if !subviewsHierarchyHasBeenConfigured {
            configureSubviewsHierarchy()
        }
        
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
    
    func configureButtons() {
        switchButton.setImage(UIImage(named: "Switch"), for: .normal)
        switchButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 4, right: 0)
        
        spaceButton.setTitle("SPACE", letterSpacing: 1.1)
        spaceSymbol.value = " "
        
        returnSymbol.value = "\n"
        
        [spaceButton, returnButton].forEach { button in
            button.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
            button.cornerRadius = 4
            button.titleLabel?.font = UIFont(name: "SFUIDisplay-Bold", size: 12)
            button.setTitleColor(.black, for: .normal)
        }
        
        deleteButton.setImage(UIImage(named: "Delete"), for: .normal)
        deleteButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 4)
        
        addGestureRecognizersOnDeleteButton()
    }
    
    func configureSubviewsHierarchy() {
        addSubview(switchButton)
        addSubview(spaceButton)
        addSubview(returnButton)
        addSubview(deleteButton)
        addSubview(collectionView)
        
        subviewsHierarchyHasBeenConfigured = true
    }
        
}

private extension KeyboardActionsTableViewCell {
    
    func bindSelf() {
        collectionView.rx.itemHighlighted
            .map { _ in }
            .bind(to: needsPlayInputClick)
            .disposed(by: bag)
        
        switchButton.rx.tap
            .bind(to: needsPlayInputClick)
            .disposed(by: bag)
        
        spaceButton.rx.tap
            .bind(to: needsPlayInputClick)
            .disposed(by: bag)
        
        returnButton.rx.tap
            .bind(to: needsPlayInputClick)
            .disposed(by: bag)
        
        spaceButton.rx.tap
            .map { [weak self] in self?.spaceSymbol }
            .bind(to: needsReactToSimpleButtonTouchEvent)
            .disposed(by: bag)
        
        returnButton.rx.tap
            .map { [weak self] in self?.returnSymbol }
            .bind(to: needsReactToSimpleButtonTouchEvent)
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

private extension KeyboardActionsTableViewCell {
    
    func layoutFrames() {
            collectionView.fillSuperview(left: 0, right: 0, top: 0, bottom: 50)
            switchButton.fillSuperview(left: 0, right: width - 44, top: 40, bottom: 0)
            spaceButton.fillSuperview(left: 50, right: 47 + (width - 88) * 0.36, top: 40, bottom: 6)
            returnButton.fillSuperview(left: 47 + (width - 88) * 0.64, right: 50, top: 40, bottom: 6)
            deleteButton.fillSuperview(left: width - 44, right: 0, top: 40, bottom: 0)
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
