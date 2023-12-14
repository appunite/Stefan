//
//  ItemReloadingResult.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public enum ItemReloadingResult<ItemType: Equatable> {
    
    ///
    /// Nothing to change on screen
    ///
    case none
    
    ///
    /// Placeholder only
    ///
    case placeholder
    
    ///
    /// Items only
    ///
    case items(oldItems: [ItemType], newItems: [ItemType])
    
    ///
    /// First placeholder then collection
    ///
    case placeholderAndItems(oldItems: [ItemType], newItems: [ItemType])
    
    ///
    /// First collection then placeholder
    ///
    case itemsAndPlaceholder(oldItems: [ItemType], newItems: [ItemType])
    
}

extension ItemReloadingResult: Equatable {
    
    public static func == (lhs: ItemReloadingResult<ItemType>, rhs: ItemReloadingResult<ItemType>) -> Bool {
        
        switch(lhs, rhs) {
            
        case (.none, .none), (.placeholder, .placeholder):
            return true
        case (.items(let lOldItems, let lNewItems), .items(let rOldItems, let rNewItems)):
            return lOldItems == rOldItems && lNewItems == rNewItems
        case (.placeholderAndItems(let lOldItems, let lNewItems), .placeholderAndItems(let rOldItems, let rNewItems)):
            return lOldItems == rOldItems && lNewItems == rNewItems
        case (.itemsAndPlaceholder(let lOldItems, let lNewItems), .itemsAndPlaceholder(let rOldItems, let rNewItems)):
            return lOldItems == rOldItems && lNewItems == rNewItems
        default:
            return false
        }
    }
    
    
    
}
