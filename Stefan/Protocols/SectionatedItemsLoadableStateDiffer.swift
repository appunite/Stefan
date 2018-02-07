//
//  SectionatedItemsLoadableStateDiffer.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public protocol SectionatedItemsLoadableStateDiffer: class {
    
    ///
    /// If you want you can provide custom states applier
    ///
    
    func load<ItemType>(newState new: SectionatedItemsLoadableState<ItemType>, withOld old: SectionatedItemsLoadableState<ItemType>) -> SectionatedItemsReloadingResult<ItemType>
    
}

extension SectionatedItemsLoadableStateDiffer {
    
    //swiftlint:disable:next cyclomatic_complexity
    public func load<ItemType>(newState new: SectionatedItemsLoadableState<ItemType>, withOld old: SectionatedItemsLoadableState<ItemType>) -> SectionatedItemsReloadingResult<ItemType> {
        
        guard new != old else { return .none }
        
        switch(old, new) {
            
        case(.idle, _):
            
            if case let .loaded(newSections) = new {
                return .placeholderAndSections(oldSections: [], newSections: newSections)
            } else {
                return .placeholder
            }
            
        case (_, .idle):
            
            fatalError("Wrong change of state - idle is only for initial state")
            
        case (.loading, .loading), (.noContent, .noContent):
            
            return .none
            
        case (.loading, .noContent), (.loading, .error), (.error, .error), (.noContent, .error), (.error, .loading), (.noContent, .loading), (.error, .noContent):
            
            return .placeholder
            
        case (.loading, .loaded(let newSections)), (.error, .loaded(let newSections)), (.noContent, .loaded(let newSections)):
            
            return .placeholderAndSections(oldSections: [], newSections: newSections)
            
        case (.loading, .refreshing):
            
            fatalError("Wrong change of state - refreshing should not occur after loading")
            
        case (.loaded(let oldSections), .loaded(let newSections)):
            
            return .sections(oldSections: oldSections, newSections: newSections)
            
        case (.refreshing(_, let oldSections), .loaded(let newSections)):
            
            return .placeholderAndSections(oldSections: oldSections, newSections: newSections)
            
        case (.refreshing, .refreshing(let rSilent, _)), (.error, .refreshing(let rSilent, _)), (.noContent, .refreshing(let rSilent, _)):
            
            if rSilent {
                return .none
            } else {
                return .placeholder
            }
            
        case (.loaded(let oldSections), .refreshing(let rSilent, _)):
            
            if rSilent {
                return .none
            } else {
                return .sectionsAndPlaceholder(oldSections: oldSections, newSections: [])
            }
            
        case (.refreshing, .loading):
            
            fatalError("Wrong change of state - loading should not occur after refreshing")
            
        case (.loaded(let oldSections), .noContent), (.loaded(let oldSections), .error), (.loaded(let oldSections), .loading):
            
            return .sectionsAndPlaceholder(oldSections: oldSections, newSections: [])
            
        case (.refreshing(let lSilent, let oldSections), .error), (.refreshing(let lSilent, let oldSections), .noContent):
            
            if lSilent {
                // table still displays sections, need to hide them
                return .sectionsAndPlaceholder(oldSections: oldSections, newSections: [])
            } else {
                return .placeholder
            }
        }
    }
}
