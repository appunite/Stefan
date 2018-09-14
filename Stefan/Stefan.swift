//
//  Stefan.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation
import DifferenceKit

public class Stefan<ItemType: Differentiable>: NSObject, ItemsLoadableStateDiffer {
    public weak var statesDiffer: ItemsLoadableStateDiffer?
    public weak var placeholderPresenter: LoadableStatePlaceholderPresentable?
    public weak var reloadableView: ReloadableView?
    public let reloadingType: ReloadingType
    
    private var _state: ItemsLoadableState<ItemType> = .idle // teporary public for writing reactive extension
    public var state: ItemsLoadableState<ItemType> {
        return _state
    }
    
    // MARK: - Delegate
    public var shouldReload: ((ReloadableView) -> Bool) = { _ in return true }
    public var didChangeState: ((ItemsLoadableState<ItemType>) -> Void) = { _ in }
    public var shouldDisplayPlaceholder: ((ItemsLoadableState<ItemType>) -> Bool) = { state in
        switch state {
        case .idle, .loaded: return false
        default: return true
        }
    }
    
    // MARK: - Init
    
    public init(reloadingType: ReloadingType = .basic) {
        self.reloadingType = reloadingType
        super.init()
        statesDiffer = self
    }

    public func load(newState: ItemsLoadableState<ItemType>) {
        let old = self._state
        
        if !newState.isLoaded {
            self._state = newState
            didChangeState(newState)
        }
    
        guard let reloadingResult = statesDiffer?.load(newState: newState, withOld: old) else {
            assertionFailure("States differ not set when loading new state")
            return
        }

        switch reloadingResult {
        case .none where shouldDisplayPlaceholder(newState) == false:
            placeholderPresenter?.removePlaceholderView()
        case .placeholder:
            if shouldDisplayPlaceholder(newState) {
                placeholderPresenter?.reloadPlaceholder(forState: newState)
            } else {
                placeholderPresenter?.removePlaceholderView()
            }
        case let .items(oldItems: oldItems, newItems: newItems):
            reloadItems(old: oldItems, new: newItems, newState: newState)
        case let .placeholderAndItems(oldItems: oldItems, newItems: newItems):
            if shouldDisplayPlaceholder(newState) {
                placeholderPresenter?.reloadPlaceholder(forState: newState)
            } else {
                placeholderPresenter?.removePlaceholderView()
            }
            reloadItems(old: oldItems, new: newItems, newState: newState)
        case let .itemsAndPlaceholder(oldItems: oldItems, newItems: newItems):
            reloadItems(old: oldItems, new: newItems, newState: newState)
            if shouldDisplayPlaceholder(newState) {
                placeholderPresenter?.reloadPlaceholder(forState: newState)
            } else {
                placeholderPresenter?.removePlaceholderView()
            }
        default: break
        }
    }
    
    public func reloadPlaceholder(force: Bool = false) {
        if force || shouldDisplayPlaceholder(_state) {
            placeholderPresenter?.reloadPlaceholder(forState: _state)
        }
    }
    
    private func reloadItems(old: [ItemType], new: [ItemType], newState: ItemsLoadableState<ItemType>) {
        guard shouldReloadView() else { return }
        switch reloadingType {
        case .animated:
            let changeSet = StagedChangeset(source: old, target: new)
            reloadableView?.reload(using: changeSet, setData: {
                guard newState.isLoaded else { return }
                let temporaryState = ItemsLoadableState($0)
                _state = temporaryState
                didChangeState(temporaryState)
            })
        case .basic:
            if newState.isLoaded {
                _state = newState
                didChangeState(newState)
            }
            reloadableView?.reload()
        }
    }
    
    private func shouldReloadView() -> Bool {
        guard let reloadableView = self.reloadableView else { return false }
        return shouldReload(reloadableView)
    }
    
}
