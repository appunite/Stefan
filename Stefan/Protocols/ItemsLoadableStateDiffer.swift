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
