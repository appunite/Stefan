//
//  StateLoadableTableViewDelegate.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public protocol StateLoadableTableViewDelegate: class {
    
    func shouldReload(reloadableView: ReloadableView!) -> Bool
}

extension StateLoadableTableViewDelegate {
    
    public func shouldReload(reloadableView: ReloadableView!) -> Bool {
        return true
    }
}
