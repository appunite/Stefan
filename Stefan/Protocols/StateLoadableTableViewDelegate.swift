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
    
    var deletionAnimation: UITableViewRowAnimation { get } // check is available insertion animation for item ?
    var insertionAnimation: UITableViewRowAnimation { get } // check is available insertion animation for item ?
    
}

extension StateLoadableTableViewDelegate {
    
    public func shouldReload(reloadableView: ReloadableView!) -> Bool {
        return true
    }
    
    public var deletionAnimation: UITableViewRowAnimation {
        return .fade
        // check is available insertion animation for item ?
    }
    
    public var insertionAnimation: UITableViewRowAnimation {
        return .fade
        // check is available insertion animation for item ?
    }
}
