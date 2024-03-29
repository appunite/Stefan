//
//  LoadableStatePlaceholderPresentable.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import UIKit

public protocol LoadableStatePlaceholderPresentable: AnyObject {
    
    ///
    /// Placeholder is accessible from here and can be customized
    ///
    var placeholderView: LoadableStatePlaceholderView? { get set }
    var placeholderContainer: UIView! { get }
    
    func addPlaceholderView()
    func removePlaceholderView()
    
    ///
    /// Custom placeholder provider
    ///
    func customPlaceholderView() -> LoadableStatePlaceholderView
    
    ///
    /// Indicates is placeholder visible on the screen
    ///
    func isDisplayingPlaceholder() -> Bool
    
    ///
    /// Reload placeholder implicilty for needed state (should be avoided)
    ///
    func reloadPlaceholder<ItemType>(forState newState: ItemsLoadableState<ItemType>)
    
}

extension LoadableStatePlaceholderPresentable {
    
    public func customPlaceholderView() -> LoadableStatePlaceholderView {
        
        return LoadableStatePlaceholderDefaultView()
    }
    
    public func reloadPlaceholder<ItemType>(forState newState: ItemsLoadableState<ItemType>) {
        
        if self.placeholderView == nil {
            self.addPlaceholderView()
        }
        
        guard let bindablePlaceholder = self.placeholderView as? ItemsLoadableStateBindable else {
            fatalError("Placeholder has to be ItemsLoadableStateBindable when using ItemsLoadableState")
        }
        
        bindablePlaceholder.bind(withState: newState)
    }
    
    public func addPlaceholderView() {
        
        let placeholder = customPlaceholderView()
        
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        
        placeholderContainer.insertSubview(placeholder, at: 0)
        
        let constraints = [
            placeholder.heightAnchor.constraint(equalTo: placeholderContainer.heightAnchor),
            placeholder.widthAnchor.constraint(equalTo: placeholderContainer.widthAnchor),
            placeholder.centerXAnchor.constraint(equalTo: placeholderContainer.centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: placeholderContainer.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        self.placeholderView = placeholder
        placeholder.setupView()
    }
    
    public func isDisplayingPlaceholder() -> Bool {
        return placeholderView != nil
    }
    
    public func removePlaceholderView() {
        
        self.placeholderView?.removeFromSuperview()
        self.placeholderView = nil
    }
}
