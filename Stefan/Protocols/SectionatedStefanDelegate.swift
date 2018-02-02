//
//  SectionatedStefanDelegate.swift
//  Stefan-iOS
//
//  Created by Szymon Mrozek on 02.02.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public protocol SectionatedStefanDelegate: class {
    
    associatedtype ItemType: Equatable
    
    var shouldReload: ((ReloadableView!) -> Bool) { get }
    var shouldDisplayPlaceholder: ((SectionatedItemsLoadableState<ItemType>) -> Bool) { get }
    var didChangeState: ((SectionatedItemsLoadableState<ItemType>) -> Void) { get }
}
