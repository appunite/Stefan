import Foundation
import UIKit
//////////////////////
// Stefan
/////////////////////


public protocol LoadableStateType {
    
    associatedtype ItemType
}

public protocol PlainLoadableStateType: LoadableStateType {
    
    var itemsCount: Int { get }
    var items: [ItemType] { get }
    
}
public protocol SectionatedLoadableStateType: LoadableStateType {
    
    var sectionsCount: Int { get }
    var items: [[ItemType]] { get }
    func itemsCount(inSection section: Int) -> Int
    func items(inSection section: Int) -> [ItemType]
    
}

public enum PlainLoadableState<T: Equatable>: PlainLoadableStateType {
    
    public typealias ItemType = T
    
    case idle
    case loading
    case noContent
    case loaded(items: [ItemType])
    case refreshing(silent: Bool, items: [ItemType])
    case error(Error)
    
    public init(_ items: [ItemType]) {
        if items.count > 0 {
            self = .loaded(items: items)
        } else {
            self = .noContent
        }
    }
    
    public var itemsCount: Int {
        switch self {
        case let .loaded(items):
            return items.count
        default:
            return 0
        }
    }
    
    public var items: [ItemType] {
        switch self {
        case let .loaded(items):
            return items
        default:
            return []
        }
    }
}

extension PlainLoadableState: Equatable {
    
    public static func ==(lhs: PlainLoadableState<T>, rhs: PlainLoadableState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.noContent, .noContent), (.error, .error):
            return true
        case (.refreshing(let lSilent, let lOldItems), .refreshing(let rSilent, let rOldItems)):
            return lSilent == rSilent // DIFFER TO IMPLEMENT
        case (.loaded(let lItems), .loaded(let rItems)):
            return false // DIFFER TO IMPLEMENT
        default:
            return false
        }
    }
    
}


public enum SectionatedLoadableState<T: Equatable>: SectionatedLoadableStateType {
    
    public typealias ItemType = T
    
    case idle
    case loading
    case noContent
    case loaded(items: [[ItemType]])
    case refreshing(silent: Bool)
    case error(Error)
    
    public init(_ items: [[ItemType]]) {
        if items.count > 0 {
            self = .loaded(items: items)
        } else {
            self = .noContent
        }
    }
    
    public var sectionsCount: Int {
        switch self {
        case let .loaded(items):
            return items.count
        default:
            return 0
        }
    }
    
    public var items: [[ItemType]] {
        switch self {
        case let .loaded(items):
            return items
        default:
            return [[]]
        }
    }
    
    public func itemsCount(inSection section: Int) -> Int {
        switch self {
        case let .loaded(items):
            guard self.sectionsCount > section else { return 0 }
            return items[section].count
        default:
            return 0
        }
    }
    
    public func items(inSection section: Int) -> [ItemType] {
        switch self {
        case let .loaded(items):
            guard self.sectionsCount > section else { return [] }
            return items[section]
        default:
            return []
        }
    }
    
}

public protocol StateLoadableTableViewDelegate: class {
    
    func shouldReload(tableView: UITableView!) -> Bool
    
    var deletionAnimation: UITableViewRowAnimation { get } // check is available insertion animation for item ?
    var insertionAnimation: UITableViewRowAnimation { get } // check is available insertion animation for item ?
    
}

extension StateLoadableTableViewDelegate {
    
    func shouldReload(tableView: UITableView!) -> Bool {
        return true
    }
    
    var deletionAnimation: UITableViewRowAnimation {
        return .fade
    }
    
    var insertionAnimation: UITableViewRowAnimation {
        return .fade
    }
}

public protocol StateLoadablePlainTableViewDataSource: UITableViewDataSource, StateLoadableTableViewDelegate {
    
    associatedtype ItemType: Equatable
    
    var state: PlainLoadableState<ItemType> { get set }
    
    func load(newState: PlainLoadableState<ItemType>)
    
    func reloadItems(old: [ItemType], new: [ItemType])
    func reloadPlaceholder(forState newState: PlainLoadableState<ItemType>)
}

extension StateLoadablePlainTableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.itemsCount
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func load(newState new: PlainLoadableState<ItemType>) {
        
        let old = self.state
        
        
        switch(old, new) {
            
        case(.idle, _):
            if case let .loaded(newItems) = new {
                reloadPlaceholder(forState: new)
                reloadItems(old: [], new: newItems)
            } else {
                reloadPlaceholder(forState: new)
            }
        case (_, .idle):
            
            fatalError("Wrong change of state - idle is only for initial state")
            
        case (.loading, .loading), (.noContent, .noContent):
            
            break // do nothing
            
        case (.loading, .noContent), (.loading, .error), (.error, .error), (.noContent, .error), (.error, .loading), (.noContent, .loading), (.error, .noContent):
            
            reloadPlaceholder(forState: new)
            
        case (.loading, .loaded(let newItems)), (.error, .loaded(let newItems)), (.noContent, .loaded(let newItems)):
            
            reloadPlaceholder(forState: new)
            reloadItems(old: [], new: newItems)
            
        case (.loading, .refreshing):
            
            fatalError("Wrong change of state - refreshing should not occur after loading")
            
        case (.loaded(let oldItems), .loaded(let newItems)):
            
            reloadItems(old: oldItems, new: newItems)
            
        case (.refreshing(_ , let oldItems), .loaded(let newItems)):
            
            reloadPlaceholder(forState: new)
            reloadItems(old: oldItems, new: newItems)
            
        case (.refreshing, .refreshing(let rSilent, _)), (.error, .refreshing(let rSilent, _)), (.noContent, .refreshing(let rSilent, _)):
            
            if rSilent == false {
                reloadPlaceholder(forState: new)
            }
            
        case (.loaded(let oldItems), .refreshing(let rSilent, _)):
            
            if rSilent == false {
                reloadItems(old: oldItems, new: [])
                reloadPlaceholder(forState: new)
            }
            
        case (.refreshing, .loading):
            
            fatalError("Wrong change of state - loading should not occur after refreshing")
            
        case (.loaded, .loading):
            
            fatalError("Wrong change of state - loading should not occur after loaded")
            
        case (.loaded(let oldItems), .noContent), (.loaded(let oldItems), .error):
            
            reloadItems(old: oldItems, new: [])
            reloadPlaceholder(forState: new)
            
        case (.refreshing(let lSilent, let oldItems), .error), (.refreshing(let lSilent, let oldItems), .noContent):
            
            if lSilent {
                // table still displays items, need to hide them
                reloadItems(old: oldItems, new: [])
            }
            reloadPlaceholder(forState: new)
        }
        
        self.state = new
    }
}

public extension StateLoadablePlainTableViewDataSource where Self: UITableViewController {
    
    public func reloadItems(old: [ItemType], new: [ItemType]) {
        
    }
}

public extension StateLoadablePlainTableViewDataSource where Self: LoadableStatePlaceholderPresentable {
    
    public func reloadPlaceholder(forState newState: PlainLoadableState<ItemType>) {
        guard let defaultPlaceholder = self.placeholderView as? LoadableStatePlaceholderDefaultView else {
            fatalError("If you use custom view for placeholder you have to implement reload placeholder method")
        }
        
        return
    }
}

public protocol LoadableStatePlaceholderPresentable: class {
    
    var placeholderView: LoadableStatePlaceholder! { get set }
    
    func addPlaceholderView(to view: UIView)
    func customPlaceholderView() -> LoadableStatePlaceholderView
}

extension LoadableStatePlaceholderPresentable {
    
    public func customPlaceholderView() -> LoadableStatePlaceholderView {
        
        return LoadableStatePlaceholderView()
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

public protocol LoadableStatePlaceholder {
    
    // setup functions to prepare labels, views etc ...
    func setup(withTableView tableView: UITableView!)
    func setup(withCollectionView collectionView: UICollectionView!)
    
}

open class LoadableStatePlaceholderView: UIView, LoadableStatePlaceholder {
    
    public func setup(withTableView tableView: UITableView!) {
        
    }
    
    public func setup(withCollectionView collectionView: UICollectionView!) {
        
    }
}

public protocol LoadableStatePlaceholderDefaultViewDataSource {
    // provide titles / subtitle / image for states ...
}

public final class LoadableStatePlaceholderDefaultView: LoadableStatePlaceholderView {
    
    var dataSource: LoadableStatePlaceholderDefaultViewDataSource?
    
    public func bind<T>(withState state: PlainLoadableState<T>) {
        
    }
    
    public func bind<T>(withState state: SectionatedLoadableState<T>) {
        
    }
}

// Extension do arraya na loadable state
// [T] ------> LoadableState<T>

////////////////////////////
// RxStefan
/////////////////////////

// Rx Wrapper dla observable ktore zwracaja array
// Observable<[T]> ----> Observable<LoadableState<T>>

// Extension z diffami dla observable ktore sa loadablestate
// let obs = Observable<LoadableState<T>>
// obs.diff() ----> Observable<(LoadableState<T>, diff)>
