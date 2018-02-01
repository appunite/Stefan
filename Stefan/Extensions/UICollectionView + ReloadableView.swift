//
//  UICollectionView + ReloadableView.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import UIKit
import Differ

extension UICollectionView: ReloadableView {
    
    public func reload() {
        self.reloadData()
    }
    
    public func reloadAnimated<ItemType>(old: [ItemType], new: [ItemType]) where ItemType: Equatable {
        self.animateItemChanges(oldData: old, newData: new)
    }

    public func reloadAnimated<ItemType>(old: [[ItemType]], new: [[ItemType]]) where ItemType: Equatable {
        // TO DO
    }
}
