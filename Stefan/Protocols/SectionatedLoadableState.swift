//
//  SectionatedLoadableState.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public protocol SectionatedLoadableState: LoadableStateType {
    
    typealias Section = [ItemType]
    
    var sectionsCount: Int { get }
    func itemsSectionated() throws -> [Section]
    func allItems() throws -> [ItemType]
    func itemsCount(inSection section: Int) throws -> Int
    func items(inSection section: Int) throws -> [ItemType]
}
