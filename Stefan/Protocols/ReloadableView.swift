//
//  ReloadableView.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public protocol ReloadableView: AnyObject {
    
    func reload()
    
    func reloadAnimated<ItemType: Equatable>(old: [ItemType], new: [ItemType])
    
}
