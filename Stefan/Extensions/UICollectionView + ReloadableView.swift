//
//  UICollectionView + ReloadableView.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

extension UICollectionView: ReloadableView {
    
    public func reload() {
        self.reloadData()
    }
}
