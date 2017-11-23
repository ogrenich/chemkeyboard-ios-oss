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
import Neon
import AudioToolbox.AudioServices

@IBDesignable
class KeyboardElementsTableViewCell: UITableViewCell {
    
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                             collectionViewLayout:
                                                                             KeyboardElementsCollectionViewLayout())
    
    
    fileprivate weak var needsReactToSimpleButtonTouchEvent: PublishSubject<Symbol?>!
    fileprivate weak var needsScrollElementsCollectionViewToCategoryAt: PublishSubject<Int>!
    fileprivate weak var needsPlayInputClick: PublishSubject<Void>!
    
    fileprivate let needsToShowExtendedPopUp = PublishSubject<KeyboardElementsCollectionViewCell>()
    
    
    fileprivate var bag = DisposeBag()
    fileprivate var viewModel: KeyboardElementsTableViewCellModel!
    
    fileprivate var userIsScrolling: Bool = false
    
    fileprivate var impactFeedbackGenerator: UIImpactFeedbackGenerator? = nil
    
    fileprivate var currentSection: RxSwift.Observable<Int> {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.fillSuperview()
        collectionView.reloadData()
    }
    
}

extension KeyboardElementsTableViewCell {
    
    @discardableResult
    func configure(with viewModel: KeyboardElementsTableViewCellModel,
                   needsReactToSimpleButtonTouchEvent: PublishSubject<Symbol?>,
                   _ needsScrollElementsCollectionViewToCategoryAt: PublishSubject<Int>,
                   _ needsPlayInputClick: PublishSubject<Void>) -> KeyboardElementsTableViewCell {
        self.viewModel = viewModel
        self.needsReactToSimpleButtonTouchEvent = needsReactToSimpleButtonTouchEvent
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

private extension KeyboardElementsTableViewCell {
    
    func setupUI() {
        backgroundColor = .clear
    }
    
}

private extension KeyboardElementsTableViewCell {
    
    func configureCollectionView() {
        if collectionView.superview == nil {
            addSubview(collectionView)
        }
        
        collectionView.register(KeyboardElementsCollectionViewCell.self)
        
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.alwaysBounceHorizontal = true
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
        
        collectionView.rx.itemHighlighted
            .map { _ in }
            .bind(to: needsPlayInputClick)
            .disposed(by: bag)
        
        collectionView.rx.itemHighlighted
            .bind { [weak self] indexPath in
                guard let `self` = self else {
                    return
                }
                
                if let cell = self.collectionView.cellForItem(at: indexPath) {
                    let frame = CGRect(x: cell.frame.origin.x - self.collectionView.contentOffset.x,
                                       y: cell.frame.origin.y + 36,
                                       width: cell.frame.width, height: cell.frame.height)
                    let element = self.viewModel.categories.value[indexPath.section].elements[indexPath.item]
                    PopUp.instance.show(element: element, at: frame, style: .simple)
                    
                    if !UIDevice.current.hasTapticEngine {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) {
                            if cell.isHighlighted {
                                PopUp.instance.show(element: element, at: frame, style: .extended)
                            }
                        }
                    }
                    
                    cell.isHidden = true
                }
            }
            .disposed(by: bag)
        
        needsToShowExtendedPopUp
            .bind { [weak self] cell in
                guard let `self` = self else {
                    return
                }
                
                if let indexPath = self.collectionView.indexPath(for: cell) {
                    let frame = CGRect(x: cell.frame.origin.x - self.collectionView.contentOffset.x,
                                       y: cell.frame.origin.y + 36,
                                       width: cell.frame.width, height: cell.frame.height)
                    let element = self.viewModel.categories.value[indexPath.section].elements[indexPath.item]
                    PopUp.instance.show(element: element, at: frame, style: .extended)
                    DispatchQueue.main.async { [weak self] in
                        if UIDevice.current.hasHapticFeedback {
                            self?.impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                            self?.impactFeedbackGenerator?.prepare()
                            self?.impactFeedbackGenerator?.impactOccurred()
                            self?.impactFeedbackGenerator = nil
                        } else if UIDevice.current.hasTapticEngine {
                            AudioServicesPlaySystemSound(1520)
                        }
                    }
                }
            }
            .disposed(by: bag)
        

        collectionView.rx.itemUnhighlighted
            .bind { [weak self] in
                guard let `self` = self else {
                    return
                }
                
                if let cell = self.collectionView.cellForItem(at: $0) as? KeyboardElementsCollectionViewCell {
                    PopUp.instance.hide()
                    cell.isHidden = false
                    cell.popUpExtended = false
                }
            }
            .disposed(by: bag)
        
        collectionView.rx.itemUnhighlighted
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
        guard let layout = collectionView.collectionViewLayout as? KeyboardElementsCollectionViewLayout else {
            return 0
        }
        
        let numberOfColumns =
            (CGFloat(viewModel.categories.value[section].elements.count / layout.numberOfRows)).rounded(.up)
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
        let element = Array(viewModel.categories.value[indexPath.section].elements)[indexPath.item]
        
        return cell.configure(with: element, needsToShowExtendedPopUp)
    }
    
}
