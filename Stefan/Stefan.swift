//
//  Stefan.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation
import DifferenceKit

public class Stefan<ItemType: Differentiable>: NSObject {
    public weak var statesDiffer: ItemsLoadableStateDiffer?
    public weak var placeholderPresenter: LoadableStatePlaceholderPresentable?
    public weak var reloadableView: ReloadableView?
    public let reloadingType: ReloadingType
    
    private var _state: ItemsLoadableState<ItemType> = .idle
    public var state: ItemsLoadableState<ItemType> {
        return _state
    }
    
    public var shouldReload: ((ReloadableView) -> Bool) = { _ in return true }
    public var didChangeState: ((ItemsLoadableState<ItemType>) -> Void) = { _ in }
    public var shouldDisplayPlaceholder: ((ItemsLoadableState<ItemType>) -> Bool) = { state in
        switch state {
        case .idle, .loaded: return false
        default: return true
        }
    }
    
    public init(reloadingType: ReloadingType = .basic) {
        self.reloadingType = reloadingType
        super.init()
        statesDiffer = self
    }

    public func load(newState: ItemsLoadableState<ItemType>) {
        let old = self._state
    
        guard let reloadingResult = statesDiffer?.load(newState: newState, withOld: old) else {
            assertionFailure("States differ not set when loading new state")
            return
        }

        switch reloadingResult {
        case .none:
            setState(newState)
            guard shouldDisplayPlaceholder(newState) == false else { break }
            placeholderPresenter?.removePlaceholderView()
        case .placeholder:
            setState(newState)
            reloadPlaceholderOrRemove(forState: newState)
        case let .items(oldItems: oldItems, newItems: newItems):
            reloadItems(old: oldItems, new: newItems, newState: newState)
        case let .placeholderAndItems(oldItems: oldItems, newItems: newItems):
            reloadPlaceholderOrRemove(forState: newState)
            reloadItems(old: oldItems, new: newItems, newState: newState)
        case let .itemsAndPlaceholder(oldItems: oldItems, newItems: newItems):
            reloadItems(old: oldItems, new: newItems, newState: newState)
            reloadPlaceholderOrRemove(forState: newState)
        }
    }
    
    public func reloadPlaceholder(force: Bool = false) {
        if force || shouldDisplayPlaceholder(_state) {
            placeholderPresenter?.reloadPlaceholder(forState: _state)
        }
    }
    
    private func setState(_ newState: ItemsLoadableState<ItemType>) {
        self._state = newState
        didChangeState(newState)
    }
    
    private func reloadPlaceholderOrRemove(forState state: ItemsLoadableState<ItemType>) {
        if shouldDisplayPlaceholder(state) {
            placeholderPresenter?.reloadPlaceholder(forState: state)
        } else {
            placeholderPresenter?.removePlaceholderView()
        }
    }
    
    private func reloadItems(old: [ItemType], new: [ItemType], newState: ItemsLoadableState<ItemType>) {
        guard shouldReloadView() else {
            setState(newState)
            return
        }
        
        switch reloadingType {
        case .animated: reloadItemsAnimated(old: old, new: new, newState: newState)
        case .basic: reloadItemsWithoutAnimation(newState: newState)
        }
    }
    
    private func reloadItemsAnimated(old: [ItemType], new: [ItemType], newState: ItemsLoadableState<ItemType>) {
        let changeSet = StagedChangeset(source: old, target: new)
        if changeSet.count == 0 {
            setState(newState)
        } else {
            reloadableView?.reload(using: changeSet, setData: {
                let temporaryState = newState.withModifiedItems($0)
                setState(temporaryState)
            })
        }
    }
    
    private func reloadItemsWithoutAnimation(newState: ItemsLoadableState<ItemType>) {
        setState(newState)
        reloadableView?.reload()
    }
    
    private func shouldReloadView() -> Bool {
        guard let reloadableView = self.reloadableView else { return false }
        return shouldReload(reloadableView)
    }
}

extension Stefan: ItemsLoadableStateDiffer {
    public func load<ItemType>(newState new: ItemsLoadableState<ItemType>, withOld old: ItemsLoadableState<ItemType>) -> ItemReloadingResult<ItemType> {
        switch(old, new) {
        case(.idle, _):
            guard case let .loaded(newItems) = new else { return .placeholder }
            return .placeholderAndItems(oldItems: [], newItems: newItems)
        case (_, .idle):
            fatalError("Wrong change of state - idle is only for initial state")
        case (.loading, .loading), (.noContent, .noContent):
            return .none
        case (.loading, .noContent), (.noContent, .loading),
             (.loading, .error), (.error, .loading),
             (.noContent, .error), (.error, .noContent),
             (.error, .error):
            return .placeholder
        case (.loading, .loaded(let newItems)),
             (.error, .loaded(let newItems)),
             (.noContent, .loaded(let newItems)):
            return .placeholderAndItems(oldItems: [], newItems: newItems)
        case (.loaded(let oldItems), .loaded(let newItems)):
            return .items(oldItems: oldItems, newItems: newItems)
        case (.loaded(let oldItems), .noContent),
             (.loaded(let oldItems), .error),
             (.loaded(let oldItems), .loading):
            return .itemsAndPlaceholder(oldItems: oldItems, newItems: [])
        }
    }
}
