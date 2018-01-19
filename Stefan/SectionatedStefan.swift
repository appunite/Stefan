//
//  SectionatedStefan.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public class SectionatedStefan<ItemType: Equatable>: NSObject, SectionatedItemsLoadableStateDiffer, StateLoadableTableViewDelegate {
    
    public weak var delegate: StateLoadableTableViewDelegate?
    
    public weak var statesDiffer: SectionatedItemsLoadableStateDiffer?
    
    public weak var placeholderPresenter: LoadableStatePlaceholderPresentable?
    
    public weak var reloadableView: ReloadableView?
    
    public let reloadingType: ReloadingType
    
    private(set) var state: SectionatedItemsLoadableState<ItemType> = .idle
    
    public init(reloadingType: ReloadingType = .animated) {
        self.reloadingType = reloadingType
        super.init()
        statesDiffer = self
        delegate = self
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
            break
        case .placeholder:
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
        case let .sections(oldSections: oldSections, newSections: newSections):
            
            if shouldReloadView() {
                switch reloadingType {
                case .animated:
                    reloadableView?.reloadAnimated(old: oldSections, new: newSections)
                case .basic:
                    reloadableView?.reload()
                }
            }
            
        case let .placeholderAndSections(oldSections: oldSections, newSections: newSections):
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
            if shouldReloadView() {
                switch reloadingType {
                case .animated:
                    reloadableView?.reloadAnimated(old: oldSections, new: newSections)
                case .basic:
                    reloadableView?.reload()
                }
            }
            
        case let .sectionsAndPlaceholder(oldSections: oldSections, newSections: newSections):
            
            if shouldReloadView() {
                switch reloadingType {
                case .animated:
                    reloadableView?.reloadAnimated(old: oldSections, new: newSections)
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
