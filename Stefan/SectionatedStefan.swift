//
//  SectionatedStefan.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public class SectionatedStefan<ItemType: Equatable>: NSObject, SectionatedItemsLoadableStateDiffer, SectionatedStefanDelegate {
    
    private typealias Section = [ItemType]
    
    public weak var statesDiffer: SectionatedItemsLoadableStateDiffer?
    
    public weak var placeholderPresenter: LoadableStatePlaceholderPresentable?
    
    public weak var reloadableView: ReloadableView?
    
    public let reloadingType: ReloadingType
    
    private(set) var state: SectionatedItemsLoadableState<ItemType> = .idle
    
    // MARK: - Delegate
    public var shouldReload: ((ReloadableView!) -> Bool) = { _ in return true }
    
    public var didChangeState: ((SectionatedItemsLoadableState<ItemType>) -> Void) = { _ in }
    
    public var shouldDisplayPlaceholder: ((SectionatedItemsLoadableState<ItemType>) -> Bool) = { state in
        switch state {
        case .idle, .loaded:
            return false
        case .refreshing(let silent, _):
            return silent == false
        default:
            return true
        }
    }
    
    // MARK: - Init
    
    public init(reloadingType: ReloadingType = .animated) {
        self.reloadingType = reloadingType
        super.init()
        statesDiffer = self
    }
    
    public func load(newState: SectionatedItemsLoadableState<ItemType>) {
        let old = self.state
        self.state = newState
        
        guard let reloadingResult = statesDiffer?.load(newState: newState, withOld: old) else {
            assertionFailure("States differ not set when loading new state")
            return
        }
        
        switch reloadingResult {
        case .none:
            
            if shouldDisplayPlaceholder(newState) == false {
                placeholderPresenter?.removePlaceholderView()
            }
            
        case .placeholder:
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
        case let .sections(oldSections: oldSections, newSections: newSections):
            
            reloadSections(old: oldSections, new: newSections)
            
        case let .placeholderAndSections(oldSections: oldSections, newSections: newSections):
            
            if shouldDisplayPlaceholder(newState) {
                placeholderPresenter?.reloadPlaceholder(forState: newState)
            } else {
                placeholderPresenter?.removePlaceholderView()
            }
            reloadSections(old: oldSections, new: newSections)
            
        case let .sectionsAndPlaceholder(oldSections: oldSections, newSections: newSections):

            reloadSections(old: oldSections, new: newSections)
            if shouldDisplayPlaceholder(newState) {
                placeholderPresenter?.reloadPlaceholder(forState: newState)
            } else {
                placeholderPresenter?.removePlaceholderView()
            }

        }
        
        didChangeState(newState)
    }
    
    private func reloadSections(old: [Section], new: [Section]) {
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
        return shouldReload(reloadableView)
    }
    
}
