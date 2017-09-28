//
//  KeyboardElementsTableViewCellModel.swift
//  Keyboard
//
//  Created by Andrey Ogrenich on 28/09/2017.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import Foundation
import RxSwift

class KeyboardElementsTableViewCellModel {
    
    fileprivate let bag = DisposeBag()
    
    weak var categories: Variable<[ElementCategory]>!
    
    
    init(with categories: Variable<[ElementCategory]>) {
        self.categories = categories
    }
    
}
