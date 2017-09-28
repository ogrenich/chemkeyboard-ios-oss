//
//  KeyboardCategoriesTableViewCell.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
class KeyboardCategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var bag = DisposeBag()
    fileprivate weak var viewModel: KeyboardCategoriesTableViewCellModel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
}

extension KeyboardCategoriesTableViewCell {
    
    @discardableResult
    func configure(with viewModel: KeyboardCategoriesTableViewCellModel) -> KeyboardCategoriesTableViewCell {
        self.viewModel = viewModel
        
        configureCollectionView()
        
        bindViewModel()
        
        return self
    }
    
}

private extension KeyboardCategoriesTableViewCell {
    
    func configureCollectionView() {
        collectionView.register(KeyboardCategoriesCollectionViewCell.self)
    }
    
}

private extension KeyboardCategoriesTableViewCell {
    
    func bindViewModel() {
        
    }
    
    func bindToViewModel() {
        
    }
    
}
