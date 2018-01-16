//
//  LoadableState.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public protocol LoadableState: LoadableStateType {
    
    var itemsCount: Int { get }
    func items() throws -> [ItemType]
    
}
