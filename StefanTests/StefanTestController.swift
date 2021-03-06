//
//  StefanTestController.swift
//  StefanTests
//
//  Created by Szymon Mrozek on 07.02.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import UIKit
@testable import Stefan

class StefanTestController: UITableViewController, LoadableStatePlaceholderPresentable {
    
    weak var placeholderView: LoadableStatePlaceholderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
