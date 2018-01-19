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
            break
        case .placeholder:
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
        case let .items(oldItems: oldItems, newItems: newItems):
            
            if shouldReloadView() {

                switch reloadingType {
                case .animated:
                    reloadableView?.reloadAnimated(old: oldItems, new: newItems)
                case .basic:
                    reloadableView?.reload()
                }
            }
            
        case let .placeholderAndItems(oldItems: oldItems, newItems: newItems):
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
            if shouldReloadView() {

                switch reloadingType {
                case .animated:
                    reloadableView?.reloadAnimated(old: oldItems, new: newItems)
                case .basic:
                    reloadableView?.reload()
                }
            }
            
        case let .itemsAndPlaceholder(oldItems: oldItems, newItems: newItems):
            
            if shouldReloadView() {

                switch reloadingType {
                case .animated:
                    reloadableView?.reloadAnimated(old: oldItems, new: newItems)
                case .basic:
                    reloadableView?.reload()
                }
            }
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
        }
    }
    
    private func shouldReloadView() -> Bool {
        guard let reloadableView = self.reloadableView else { return false }
        return delegate?.shouldReload(reloadableView: reloadableView) ?? true
    }
    
}
