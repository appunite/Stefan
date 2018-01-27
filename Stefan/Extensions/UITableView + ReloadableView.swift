//
//  UITableView + ReloadableView.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import UIKit
import Differ

extension UITableView: ReloadableView {

    public func reload() {
        self.reloadData()
    }

    public func reloadAnimated<ItemType>(old: [ItemType], new: [ItemType]) where ItemType : Equatable {
        let diff = old.extendedDiff(new)
        
        // for now lets use fade animation, but we need to implement that better
        self.apply(diff, deletionAnimation: .fade, insertionAnimation: .fade)
    }
    
    public func reloadAnimated<ItemType>(old: [[ItemType]], new: [[ItemType]]) where ItemType : Equatable {
        // TO DO 
    }
}
