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
    
    fileprivate var bag = DisposeBag()
    fileprivate weak var viewModel: KeyboardElementsTableViewCellModel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
}

extension KeyboardElementsTableViewCell {
    
    @discardableResult
    func configure(with viewModel: KeyboardElementsTableViewCellModel) -> KeyboardElementsTableViewCell {
        self.viewModel = viewModel
        
        configureCollectionView()
        
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
    
    func bindToViewModel() {
        
    }
    
    func bindViewModel() {
        
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
