//
//  ItemReloadingResult.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation
import DifferenceKit

public enum ItemReloadingResult<ItemType: Differentiable> {
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
