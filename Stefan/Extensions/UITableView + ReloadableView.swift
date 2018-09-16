//
//  UITableView + ReloadableView.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import UIKit
import DifferenceKit

extension UITableView: ReloadableView {
    public func reload() {
        self.reloadData()
    }
    
    public func reload<C>(using stagedChangeset: StagedChangeset<C>, setData: (C) -> Void) where C : Collection {
        reload(using: stagedChangeset, with: .automatic, setData: setData)
    }
}
