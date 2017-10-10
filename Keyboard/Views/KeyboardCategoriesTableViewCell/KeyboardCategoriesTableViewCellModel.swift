//
//  KeyboardCategoriesTableViewCellModel.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation
import RxSwift

class KeyboardCategoriesTableViewCellModel {
    
    fileprivate let bag = DisposeBag()
    
    weak var selectedCategory: Variable<ElementCategory?>!
    weak var categories: Variable<[ElementCategory]>!
    
    
    init(with categories: Variable<[ElementCategory]>,
         selectedCategory: Variable<ElementCategory?>) {
        self.selectedCategory = selectedCategory
        self.categories = categories
    }
    
}
