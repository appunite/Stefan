//
//  UIViewController + LoadableStatePlaceholderPresentable.swift
//  Stefan-iOS
//
//  Created by Szymon Mrozek on 30.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import UIKit

extension LoadableStatePlaceholderPresentable where Self: UIViewController {
    public weak var placeholderContainer: UIView! {
        return self.view
    }
}
