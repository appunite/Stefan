//
//  ReloadableView.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation
import DifferenceKit

public protocol ReloadableView: class {    
    func reload()
    func reload<C>(using stagedChangeset: DifferenceKit.StagedChangeset<C>, setData: (C) -> Void) where C : Collection
}
