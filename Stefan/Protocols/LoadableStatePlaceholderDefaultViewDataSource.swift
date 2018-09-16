//
//  LoadableStatePlaceholderDefaultViewDataSource.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public protocol LoadableStatePlaceholderDefaultViewDataSource: class {
    func title<ItemType>(forState state: ItemsLoadableState<ItemType>) -> String
    func subtitle<ItemType>(forState state: ItemsLoadableState<ItemType>) -> String
    func shouldIndicatorAnimate<ItemType>(forState state: ItemsLoadableState<ItemType>) -> Bool
}

extension LoadableStatePlaceholderDefaultViewDataSource {
    public func title<ItemType>(forState state: ItemsLoadableState<ItemType>) -> String {
        switch state {
        case .idle, .loaded:
            return ""
        case .noContent:
            return "No content"
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
        case .loading:
            return "Please wait"
        case .error(let error):
            return error.localizedDescription
        }
    }

    public func shouldIndicatorAnimate<ItemType>(forState state: ItemsLoadableState<ItemType>) -> Bool {
        switch state {
        case .loading: return true
        default: return false
        }
    }
}
