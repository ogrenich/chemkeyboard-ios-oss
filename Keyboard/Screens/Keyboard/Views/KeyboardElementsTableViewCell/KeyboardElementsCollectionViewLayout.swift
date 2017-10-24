//
//  KeyboardElementsCollectionViewLayout.swift
//  Keyboard
//
//  Created by Maria Dagaeva on 03.10.17.
//  Copyright © 2017 Chemistry Open Intelligence Pte. Ltd. All rights reserved.
//

import UIKit

class KeyboardElementsCollectionViewLayout: UICollectionViewLayout {

    fileprivate let numberOfRows: Int = 3
    fileprivate let cellPadding: CGFloat = 4
    fileprivate let cellWidth: CGFloat = 58
    fileprivate let cellHeight: CGFloat = 44

    fileprivate var cache = [[UICollectionViewLayoutAttributes]]()

    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        let contentInset = collectionView.contentInset
        return collectionView.bounds.height - (contentInset.top + contentInset.bottom)
    }
    
    fileprivate var contentWidth: CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    

    override func prepare() {
        guard
            let collectionView = collectionView,
            cache.isEmpty
        else {
            return
        }
        
        var rowNumber: Int = 0
        var columnNumber: Int = 0

        for section in 0..<collectionView.numberOfSections {
            var cacheForSection = [UICollectionViewLayoutAttributes]()

            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)

                let width: CGFloat = cellWidth + 2 * cellPadding
                let height: CGFloat = cellHeight + 2 * cellPadding
                let frame = CGRect(x: cellPadding + width * CGFloat(columnNumber),
                                   y: height * CGFloat(rowNumber),
                                   width: width, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                attributes.zIndex = rowNumber
                cacheForSection.append(attributes)

                contentWidth = max(contentWidth, frame.maxX + cellPadding)

                rowNumber += 1
                
                if rowNumber == numberOfRows {
                    rowNumber = 0
                    columnNumber += 1
                }
            }

            if rowNumber != 0 {
                columnNumber += 1
                rowNumber = 0
            }

            cache.append(cacheForSection)
        }

    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        for section in 0..<cache.count {
            for attributes in cache[section] {
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
        }

        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.section][indexPath.item]
    }

}
