//
//  ItemsLoadableState.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public enum ItemsLoadableState<T: Equatable>: LoadableState {
    
    public enum ItemsLoadableStateError: Error {
        case wrongStateForReadingItems
        case zeroItemsInLoadedState
    }
    
    public typealias ItemType = T
    
    ///
    /// Initial state
    ///
    case idle
    
    ///
    /// Items are loading right now
    ///
    case loading
    
    ///
    /// No items to show
    ///
    case noContent
    
    ///
    /// Loaded non-empty items
    ///
    case loaded(items: [ItemType])
    
    ///
    /// Refreshing content (mostly from .loaded state)
    /// If silent is set to true placeholder will not be presented
    ///
    case refreshing(silent: Bool, items: [ItemType])
    case error(Error)
    
    ///
    /// State might be initialied with items array, result is .loaded(...) when not empty or .noContent
    ///
    
    public init(_ items: [ItemType]) {
        self = ItemsLoadableState.setStateForItems(items)
    }
    
    ///
    /// Get items count from loaded state or 0
    ///
    
    public var itemsCount: Int {
        switch self {
        case let .loaded(items):
            return items.count
        default:
            return 0
        }
    }
    
    ///
    /// Get items - should be called only in non-empty .loaded state, in other case wrongStateForReadingItems or zeroItemsInLoadedState will be thrown
    ///
    
    public func items() throws -> [ItemType] {
        
        switch self {
        case let .loaded(items):
            guard items.isEmpty == false else {
                throw ItemsLoadableStateError.zeroItemsInLoadedState
            }
            return items

        case let .refreshing(silent, items):
            guard silent else {
                throw ItemsLoadableStateError.wrongStateForReadingItems
            }
            return items
            
        default:
            throw ItemsLoadableStateError.wrongStateForReadingItems
        }
    }
    
    private static func setStateForItems(_ items: [ItemType]) -> ItemsLoadableState<ItemType> {
        if items.isEmpty {
            return .noContent
        } else {
            return .loaded(items: items)
        }
    }
}

extension ItemsLoadableState: Equatable {
    
    public static func == (lhs: ItemsLoadableState<T>, rhs: ItemsLoadableState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.noContent, .noContent), (.error, .error):
            return true
        case (.refreshing(let lSilent, let lOldItems), .refreshing(let rSilent, let rOldItems)):
            let diff = lOldItems.diff(rOldItems)
            return lSilent == rSilent && diff.count == 0
        case (.loaded(let lItems), .loaded(let rItems)):
            let diff = lItems.diff(rItems)
            return diff.count == 0
        default:
            return false
        }
    }
    
}
