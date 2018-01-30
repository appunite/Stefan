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
    
    private var _state: ItemsLoadableState<ItemType> = .idle
    
    public var state: ItemsLoadableState<ItemType> {
        return _state
    }
    
    public init(reloadingType: ReloadingType = .animated) {
        self.reloadingType = reloadingType
        super.init()
        statesDiffer = self
        delegate = self
    }

    public func load(newState: ItemsLoadableState<ItemType>) {
        let old = self.state
        self._state = newState
        
        guard let reloadingResult = statesDiffer?.load(newState: newState, withOld: old) else {
            assertionFailure("States differ not set when loading new state")
            return
        }
        
        switch reloadingResult {
        case .none:
            
            if shouldDisplayPlaceholder(forState: newState) {
                break
            } else {
                placeholderPresenter?.removePlaceholderView()
            }
            
        case .placeholder:
            
            if shouldDisplayPlaceholder(forState: newState) {
                placeholderPresenter?.reloadPlaceholder(forState: newState)
            } else {
                placeholderPresenter?.removePlaceholderView()
            }
            
        case let .items(oldItems: oldItems, newItems: newItems):
            
            reloadItems(old: oldItems, new: newItems)
            
        case let .placeholderAndItems(oldItems: oldItems, newItems: newItems):
            
            if shouldDisplayPlaceholder(forState: newState) {
                placeholderPresenter?.reloadPlaceholder(forState: newState)
            } else {
                placeholderPresenter?.removePlaceholderView()
            }
            reloadItems(old: oldItems, new: newItems)
            
        case let .itemsAndPlaceholder(oldItems: oldItems, newItems: newItems):
            
            reloadItems(old: oldItems, new: newItems)
            if shouldDisplayPlaceholder(forState: newState) {
                placeholderPresenter?.reloadPlaceholder(forState: newState)
            } else {
                placeholderPresenter?.removePlaceholderView()
            }
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
    
    private func shouldDisplayPlaceholder(forNewState state: ItemsLoadableState<ItemType>) -> Bool {
        return delegate?.shouldDisplayPlaceholder(forState: state) ?? false
    }
    
}
