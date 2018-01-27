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
    
    public func load<ItemType>(newState new: ItemsLoadableState<ItemType>, withOld old: ItemsLoadableState<ItemType>) -> ItemReloadingResult<ItemType> {
        
        guard new != old else { return .none }
        
        switch(old, new) {
            
        case(.idle, _):
            
            if case let .loaded(newItems) = new {
                return .placeholderAndItems(oldItems: [], newItems: newItems)
            } else {
                return .placeholder
            }
            
        case (_, .idle):
            
            fatalError("Wrong change of state - idle is only for initial state")
            
        case (.loading, .loading), (.noContent, .noContent):
            
            return .none
            
        case (.loading, .noContent), (.loading, .error), (.error, .error), (.noContent, .error), (.error, .loading), (.noContent, .loading), (.error, .noContent):
            
            return .placeholder
            
        case (.loading, .loaded(let newItems)), (.error, .loaded(let newItems)), (.noContent, .loaded(let newItems)):
            
            return .placeholderAndItems(oldItems: [], newItems: newItems)
            
        case (.loading, .refreshing):
            
            fatalError("Wrong change of state - refreshing should not occur after loading")
            
        case (.loaded(let oldItems), .loaded(let newItems)):
            
            return .items(oldItems: oldItems, newItems: newItems)
            
        case (.refreshing(_ , let oldItems), .loaded(let newItems)):
            
            return .placeholderAndItems(oldItems: oldItems, newItems: newItems)
            
        case (.refreshing, .refreshing(let rSilent, _)), (.error, .refreshing(let rSilent, _)), (.noContent, .refreshing(let rSilent, _)):
            
            if rSilent {
                return .none
            } else {
                return .placeholder
            }
            
        case (.loaded(let oldItems), .refreshing(let rSilent, _)):
            
            if rSilent {
                return .none
            } else {
                return .itemsAndPlaceholder(oldItems: oldItems, newItems: [])
            }
            
        case (.refreshing, .loading):
            
            fatalError("Wrong change of state - loading should not occur after refreshing")
            
        case (.loaded, .loading):
            
            fatalError("Wrong change of state - loading should not occur after loaded")
            
        case (.loaded(let oldItems), .noContent), (.loaded(let oldItems), .error):
            
            return .itemsAndPlaceholder(oldItems: oldItems, newItems: [])
            
        case (.refreshing(let lSilent, let oldItems), .error), (.refreshing(let lSilent, let oldItems), .noContent):
            
            if lSilent {
                // table still displays items, need to hide them
                return .itemsAndPlaceholder(oldItems: oldItems, newItems: [])
            } else {
                return .placeholder
            }
        }
    }
}

