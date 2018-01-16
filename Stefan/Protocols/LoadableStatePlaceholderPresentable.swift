//
//  LoadableStatePlaceholderPresentable.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public protocol LoadableStatePlaceholderPresentable: class {
    
    var placeholderView: LoadableStatePlaceholderView! { get set }
    
    func addPlaceholderView(to view: UIView)
    func customPlaceholderView() -> LoadableStatePlaceholderView
    
    func reloadPlaceholder<ItemType>(forState newState: SectionatedItemsLoadableState<ItemType>)
    func reloadPlaceholder<ItemType>(forState newState: ItemsLoadableState<ItemType>)
    
}


extension LoadableStatePlaceholderPresentable {
    
    public func customPlaceholderView() -> LoadableStatePlaceholderView {
        
        return LoadableStatePlaceholderDefaultView()
    }
    
    
    public func reloadPlaceholder<ItemType>(forState newState: ItemsLoadableState<ItemType>) {
        
        guard let bindablePlaceholder = self.placeholderView as? ItemsLoadableStateBindable else {
            fatalError("Placeholder has to be ItemsLoadableStateBindable when using ItemsLoadableState")
        }
        
        bindablePlaceholder.bind(withState: newState)
    }
    
    public func reloadPlaceholder<ItemType>(forState newState: SectionatedItemsLoadableState<ItemType>) {
        
        guard let bindablePlaceholder = self.placeholderView as? SectionatedItemsLoadableStateBindable else {
            fatalError("Placeholder has to be SectionatedItemsLoadableStateBindable when using SectionatedItemsLoadableState")
        }
        
        bindablePlaceholder.bind(withState: newState)
    }
}

extension LoadableStatePlaceholderPresentable where Self: UITableViewController {
    
    func addPlaceholderView(to view: UIView) {
        
        let placeholder = customPlaceholderView()
        
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(placeholder)
        
        let constraints = [
            placeholder.leadingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholder.topAnchor.constraint(equalTo: view.topAnchor),
            placeholder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholder.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        self.placeholderView = placeholder
        placeholder.setup(withTableView: self.tableView)
    }
}

extension LoadableStatePlaceholderPresentable where Self: UICollectionViewController {
    
    func addPlaceholderView(to view: UIView) {
        
        guard let collectionView = self.collectionView else { return }
        
        let placeholder = customPlaceholderView()
        
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(placeholder)
        
        let constraints = [
            placeholder.leadingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholder.topAnchor.constraint(equalTo: view.topAnchor),
            placeholder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholder.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        self.placeholderView = placeholder
        placeholder.setup(withCollectionView: collectionView)
    }
}
