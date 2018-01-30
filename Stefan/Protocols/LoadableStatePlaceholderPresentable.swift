//
//  LoadableStatePlaceholderPresentable.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import UIKit

public protocol LoadableStatePlaceholderPresentable: class {
    
    weak var placeholderView: LoadableStatePlaceholderView? { get set }
    weak var placeholderContainer: UIView! { get }
    
    func addPlaceholderView()
    func removePlaceholderView()
    
    func customPlaceholderView() -> LoadableStatePlaceholderView
    
    func reloadPlaceholder<ItemType>(forState newState: SectionatedItemsLoadableState<ItemType>)
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
    
    public func reloadPlaceholder<ItemType>(forState newState: SectionatedItemsLoadableState<ItemType>) {
        
        if self.placeholderView == nil {
            self.addPlaceholderView()
        }
        
        guard let bindablePlaceholder = self.placeholderView as? SectionatedItemsLoadableStateBindable else {
            fatalError("Placeholder has to be SectionatedItemsLoadableStateBindable when using SectionatedItemsLoadableState")
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
    
    public func removePlaceholderView() {
        
        self.placeholderView?.removeFromSuperview()
        self.placeholderView = nil
    }
}
