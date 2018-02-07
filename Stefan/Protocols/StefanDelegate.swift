//
//  StefanDelegate.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public protocol StefanDelegate: class {
    
    associatedtype ItemType: Equatable
    
    var shouldReload: ((ReloadableView!) -> Bool) { get }
    var shouldDisplayPlaceholder: ((ItemsLoadableState<ItemType>) -> Bool) { get }
    var didChangeState: ((ItemsLoadableState<ItemType>) -> Void) { get }
}
