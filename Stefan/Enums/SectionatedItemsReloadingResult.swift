//
//  SectionatedItemsReloadingResult.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public enum SectionatedItemsReloadingResult<ItemType: Equatable> {
    
    public typealias Section = SectionatedItemsLoadableState<ItemType>.Section
    
    // nothing to change on screen
    case none
    
    // only placeholder
    case placeholder
    
    // only collection
    case sections(oldSections: [Section], newSections: [Section])
    
    // first placeholder then collection
    case placeholderAndSections(oldSections: [Section], newSections: [Section])
    
    // first collection then placeholder
    case sectionsAndPlaceholder(oldSections: [Section], newSections: [Section])
    
}
