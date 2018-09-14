//
//  ItemsLoadableStateDiffer.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public protocol ItemsLoadableStateDiffer: class {
    
    ///
    /// If you want you can provide custom states applier
    ///
    func load<ItemType>(newState new: ItemsLoadableState<ItemType>, withOld old: ItemsLoadableState<ItemType>) -> ItemReloadingResult<ItemType>
}

extension ItemsLoadableStateDiffer {
    
    //swiftlint:disable:next cyclomatic_complexity
    public func load<ItemType>(newState new: ItemsLoadableState<ItemType>, withOld old: ItemsLoadableState<ItemType>) -> ItemReloadingResult<ItemType> {
        switch(old, new) {
        case(.idle, _):
            if case let .loaded(newItems) = new {
                return .placeholderAndItems(oldItems: [], newItems: newItems)
            } else {
                return .placeholder
            }
        case (_, .idle): fatalError("Wrong change of state - idle is only for initial state")
        case (.loading, .loading), (.noContent, .noContent): return .none
        case (.loading, .noContent), (.loading, .error), (.error, .error), (.noContent, .error), (.error, .loading), (.noContent, .loading), (.error, .noContent): return .placeholder
        case (.loading, .loaded(let newItems)), (.error, .loaded(let newItems)), (.noContent, .loaded(let newItems)): return .placeholderAndItems(oldItems: [], newItems: newItems)
        case (.loaded(let oldItems), .loaded(let newItems)): return .items(oldItems: oldItems, newItems: newItems)
        case (.loaded(let oldItems), .noContent), (.loaded(let oldItems), .error), (.loaded(let oldItems), .loading): return .itemsAndPlaceholder(oldItems: oldItems, newItems: [])
        }
    }
}
