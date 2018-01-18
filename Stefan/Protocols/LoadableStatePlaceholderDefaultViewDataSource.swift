//
//  LoadableStatePlaceholderDefaultViewDataSource.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public protocol LoadableStatePlaceholderDefaultViewDataSource: class {
    
    // provide titles / subtitle / image for states ...
    
    // we can develop 2 data sources for default implementation or
    // do something like :
    
    // - title(forItemsLoadableState ...
    // - title(forSectionatedItemsLoadableState ...
    
    func title<ItemType>(forState state: ItemsLoadableState<ItemType>) -> String
    func title<ItemType>(forState state: SectionatedItemsLoadableState<ItemType>) -> String
    
    func subtitle<ItemType>(forState state: ItemsLoadableState<ItemType>) -> String
    func subtitle<ItemType>(forState state: SectionatedItemsLoadableState<ItemType>) -> String
    
    func shouldIndicatorAnimate<ItemType>(forState state: ItemsLoadableState<ItemType>) -> Bool
    func shouldIndicatorAnimate<ItemType>(forState state: SectionatedItemsLoadableState<ItemType>) -> Bool

}


extension LoadableStatePlaceholderDefaultViewDataSource {
    
    public func title<ItemType>(forState state: ItemsLoadableState<ItemType>) -> String {
        switch state {
        case .idle, .loaded:
            return ""
        case .noContent:
            return "No content"
        case .refreshing:
            return "Refreshing"
        case .loading:
            return "Loading"
        case .error:
            return "Error"
        }
    }
    
    public func title<ItemType>(forState state: SectionatedItemsLoadableState<ItemType>) -> String {
        switch state {
        case .idle, .loaded:
            return ""
        case .noContent:
            return "No content"
        case .refreshing:
            return "Refreshing"
        case .loading:
            return "Loading"
        case .error:
            return "Error"
        }
    }
    
    public func subtitle<ItemType>(forState state: ItemsLoadableState<ItemType>) -> String {
        switch state {
        case .idle, .loaded, .noContent:
            return ""
        case .refreshing, .loading:
            return "Please wait"
        case .error(let error):
            return error.localizedDescription
        }
    }
    
    public func subtitle<ItemType>(forState state: SectionatedItemsLoadableState<ItemType>) -> String {
        switch state {
        case .idle, .loaded, .noContent:
            return ""
        case .refreshing, .loading:
            return "Please wait"
        case .error(let error):
            return error.localizedDescription
        }
    }
    
    public func shouldIndicatorAnimate<ItemType>(forState state: ItemsLoadableState<ItemType>) -> Bool {
        switch state {
        case .loading:
            return true
        case .refreshing(let silent, _):
            return silent == false
        default:
            return false
        }
    }
    
    public func shouldIndicatorAnimate<ItemType>(forState state: SectionatedItemsLoadableState<ItemType>) -> Bool {
        switch state {
        case .loading:
            return true
        case .refreshing(let silent, _):
            return silent == false
        default:
            return false
        }
    }

}
