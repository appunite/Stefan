//
//  Stefan.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public class Stefan<ItemType: Equatable>: NSObject, ItemsLoadableStateDiffer, StateLoadableTableViewDelegate {
    
    public weak var delegate: StateLoadableTableViewDelegate?
    
    public weak var statesDiffer: ItemsLoadableStateDiffer?
    
    public weak var placeholderPresenter: LoadableStatePlaceholderPresentable?
    
    public weak var reloadableView: ReloadableView?
    
    public let reloadingType: ReloadingType
    
    private var state: ItemsLoadableState<ItemType> = .idle
    
    public func getState() -> ItemsLoadableState<ItemType> {
        return state
    }
    
    public init(reloadingType: ReloadingType = .animated) {
        self.reloadingType = reloadingType
        super.init()
        statesDiffer = self
        delegate = self
    }

    public func load(newState: ItemsLoadableState<ItemType>) {
        let old = self.state
        self.state = newState
        
        guard let reloadingResult = statesDiffer?.load(newState: newState, withOld: old) else {
            assertionFailure("States differ not set when loading new state")
            return
        }
        
        switch reloadingResult {
        case .none:
            
            // nothing to do
            break
            
        case .placeholder:
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
        case let .items(oldItems: oldItems, newItems: newItems):
            
            reloadItems(old: oldItems, new: newItems)
            
        case let .placeholderAndItems(oldItems: oldItems, newItems: newItems):
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            reloadItems(old: oldItems, new: newItems)
            
        case let .itemsAndPlaceholder(oldItems: oldItems, newItems: newItems):
            
            reloadItems(old: oldItems, new: newItems)
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
        }
    }
    
    private func reloadItems(old: [ItemType], new: [ItemType]) {
        guard shouldReloadView() else { return }
        switch reloadingType {
        case .animated:
            reloadableView?.reloadAnimated(old: old, new: new)
        case .basic:
            reloadableView?.reload()
        }
    }
    
    private func shouldReloadView() -> Bool {
        guard let reloadableView = self.reloadableView else { return false }
        return delegate?.shouldReload(reloadableView: reloadableView) ?? true
    }
    
}
