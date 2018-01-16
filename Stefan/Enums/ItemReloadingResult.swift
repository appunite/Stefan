//
//  ItemReloadingResult.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public enum ItemReloadingResult<ItemType: Equatable> {
    
    // nothing to change on screen
    case none
    
    // only placeholder
    case placeholder
    
    // only collection
    case items(oldItems: [ItemType], newItems: [ItemType])
    
    // first placeholder then collection
    case placeholderAndItems(oldItems: [ItemType], newItems: [ItemType])
    
    // first collection then placeholder
    case itemsAndPlaceholder(oldItems: [ItemType], newItems: [ItemType])
    
}
