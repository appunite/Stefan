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
    
    private var state: ItemsLoadableState<ItemType> = .idle
    
    public func getState() -> ItemsLoadableState<ItemType> {
        return state
    }
    
    public override init() {
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
            break
        case .placeholder:
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
        case let .items(oldItems: oldItems, newItems: newItems):
            
            if shouldReloadView() {
                // apply diff or reload for table view
                reloadableView?.reload()
            }
            
        case let .placeholderAndItems(oldItems: oldItems, newItems: newItems):
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
            if shouldReloadView() {
                // apply diff or reload for table view
                reloadableView?.reload()
            }
            
        case let .itemsAndPlaceholder(oldItems: oldItems, newItems: newItems):
            
            if shouldReloadView() {
                // apply diff for or reload table view
                reloadableView?.reload()
            }
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
        }
    }
    
    private func shouldReloadView() -> Bool {
        guard let reloadableView = self.reloadableView else { return false }
        return delegate?.shouldReload(reloadableView: reloadableView) ?? true
    }
    
}
