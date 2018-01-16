//
//  SectionatedItemsLoadableState.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public enum SectionatedItemsLoadableState<T: Equatable>: SectionatedLoadableState {
    
    public enum SectionatedItemsLoadableStateError: Error {
        case wrongStateForReadingSections
        case wrongStateForReadingItems
        case wrongStateForReadingItemsCount
        case zeroSectionsInLoadedState
        case zeroItemsInSectionAtLoadedState
        case sectionOutOfRange
    }
    
    public typealias ItemType = T
    
    case idle
    case loading
    case noContent
    case loaded(sections: [Section])
    case refreshing(silent: Bool, sections: [Section])
    case error(Error)
    
    public init(_ items: [Section]) {
        self = SectionatedItemsLoadableState.setStateForItems(items)
    }
    
    public var sectionsCount: Int {
        switch self {
        case let .loaded(sections):
            return sections.count
        default:
            return 0
        }
    }
    
    public func itemsSectionated() throws -> [Section] {
        switch self {
        case let .loaded(sections):
            guard sections.isEmpty == false else {
                throw SectionatedItemsLoadableStateError.zeroSectionsInLoadedState
            }
            return sections
        default:
            throw SectionatedItemsLoadableStateError.wrongStateForReadingSections
        }
    }
    
    public func allItems() throws -> [ItemType] {
        switch self {
        case let .loaded(sections):
            guard sections.isEmpty == false else {
                throw SectionatedItemsLoadableStateError.zeroSectionsInLoadedState
            }
            return sections.reduce([], +)
        default:
            throw SectionatedItemsLoadableStateError.wrongStateForReadingItems
        }
    }
    
    public func itemsCount(inSection section: Int) throws -> Int {
        switch self {
        case let .loaded(sections):
            guard sections.count > section else {
                throw SectionatedItemsLoadableStateError.sectionOutOfRange
            }
            return sections[section].count
        default:
            throw SectionatedItemsLoadableStateError.wrongStateForReadingItemsCount
        }
    }
    
    public func items(inSection section: Int) throws -> [ItemType] {
        switch self {
        case let .loaded(sections):
            guard sections.isEmpty == false else {
                throw SectionatedItemsLoadableStateError.zeroSectionsInLoadedState
            }
            guard sections.count > section else {
                throw SectionatedItemsLoadableStateError.sectionOutOfRange
            }
            return sections[section]
        default:
            throw SectionatedItemsLoadableStateError.wrongStateForReadingItems
        }
    }
    
    private static func setStateForItems(_ sections: [Section]) -> SectionatedItemsLoadableState<ItemType> {
        if sections.isEmpty {
            return .noContent
        } else {
            return .loaded(sections: sections)
        }
    }
    
}

extension SectionatedItemsLoadableState: Equatable {
    
    public static func ==(lhs: SectionatedItemsLoadableState<T>, rhs: SectionatedItemsLoadableState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.noContent, .noContent), (.error, .error):
            return true
        case (.refreshing(let lSilent, let lOldSections), .refreshing(let rSilent, let rOldSections)):
            return lSilent == rSilent // DIFFER TO IMPLEMENT
        case (.loaded(let lSections), .loaded(let rSections)):
            return false // DIFFER TO IMPLEMENT
        default:
            return false
        }
    }
}

