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
    
    case idle
    case loading
    case noContent
    case loaded(items: [ItemType])
    case refreshing(silent: Bool, items: [ItemType])
    case error(Error)
    
    public init(_ items: [ItemType]) {
        self = ItemsLoadableState.setStateForItems(items)
    }
    
    public var itemsCount: Int {
        switch self {
        case let .loaded(items):
            return items.count
        default:
            return 0
        }
    }
    
    public func items() throws -> [ItemType] {
        
        switch self {
        case let .loaded(items):
            guard items.isEmpty == false else {
                throw ItemsLoadableStateError.zeroItemsInLoadedState
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
    
    public static func ==(lhs: ItemsLoadableState<T>, rhs: ItemsLoadableState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.noContent, .noContent), (.error, .error):
            return true
        case (.refreshing(let lSilent, let lOldItems), .refreshing(let rSilent, let rOldItems)):
            return lSilent == rSilent // DIFFER TO IMPLEMENT
        case (.loaded(let lItems), .loaded(let rItems)):
            return false // DIFFER TO IMPLEMENT
        default:
            return false
        }
    }
    
}
