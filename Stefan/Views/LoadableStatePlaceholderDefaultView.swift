//
//  LoadableStatePlaceholderDefaultView.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public final class LoadableStatePlaceholderDefaultView: LoadableStatePlaceholderView, ItemsLoadableStateBindable, SectionatedItemsLoadableStateBindable {
    
    //
    // Use dataSource to provide title / subtitle or image for states
    //
    
    var dataSource: LoadableStatePlaceholderDefaultViewDataSource?
    
    //
    //
    //
    
    public func bind<ItemType>(withState state: ItemsLoadableState<ItemType>) {
        
    }
    
    //
    //
    //
    
    public func bind<T>(withState state: SectionatedItemsLoadableState<T>) {
        
    }
}
