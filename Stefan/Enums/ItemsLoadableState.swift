//
//  ItemsLoadableState.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation
import DifferenceKit

public enum ItemsLoadableState<T: Differentiable>: LoadableState {

    public typealias ItemType = T

    case idle
    case loading
    case noContent
    case loaded(items: [ItemType])
    case error(Error)
    
    public init(_ items: [ItemType]) {
        self = ItemsLoadableState.setStateForItems(items)
    }

    public var itemsCount: Int {
        switch self {
        case let .loaded(items): return items.count
        default: return 0
        }
    }
    
    public func items() throws -> [ItemType] {
        switch self {
        case let .loaded(items): return items
        default: return []
        }
    }
    
    var isLoaded: Bool {
        switch self {
        case .loaded: return true
        default: return false
        }
    }
    
    private static func setStateForItems(_ items: [ItemType]) -> ItemsLoadableState<ItemType> {
        return items.isEmpty ? .noContent : .loaded(items: items)
    }
}
