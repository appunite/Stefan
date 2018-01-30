//
//  StateLoadableTableViewDelegate.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public protocol StateLoadableTableViewDelegate: class {
    
    func shouldReload(reloadableView: ReloadableView!) -> Bool
    func shouldDisplayPlaceholder<ItemType>(forState state: ItemsLoadableState<ItemType>) -> Bool
    func shouldDisplayPlaceholder<ItemType>(forState state: SectionatedItemsLoadableState<ItemType>) -> Bool
    
    // should animate on in if yes - with what kind of animation
    // should animate on out
    // will show
    // did show
    // will disappear
    // did disappear
    
    // did tap

}

extension StateLoadableTableViewDelegate {
    
    public func shouldReload(reloadableView: ReloadableView!) -> Bool {
        return true
    }
    
    public func shouldDisplayPlaceholder<ItemType>(forState state: ItemsLoadableState<ItemType>) -> Bool {
        switch state {
        case .idle, .loaded:
            return false
        case .refreshing(let silent, _):
            return silent == false
        default:
            return true
        }
    }
    
    public func shouldDisplayPlaceholder<ItemType>(forState state: SectionatedItemsLoadableState<ItemType>) -> Bool {
        switch state {
        case .idle, .loaded:
            return false
        case .refreshing(let silent, _):
            return silent == false
        default:
            return true
        }
    }
}
