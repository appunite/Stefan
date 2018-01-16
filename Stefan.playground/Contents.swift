
import Foundation
import UIKit

public protocol LoadableStateType {
    
    associatedtype ItemType
}

public protocol LoadableState: LoadableStateType {
    
    var itemsCount: Int { get }
    func items() throws -> [ItemType]
    
}

public protocol SectionatedLoadableState: LoadableStateType {
    
    typealias Section = [ItemType]
    
    var sectionsCount: Int { get }
    func itemsSectionated() throws -> [Section]
    func allItems() throws -> [ItemType]
    func itemsCount(inSection section: Int) throws -> Int
    func items(inSection section: Int) throws -> [ItemType]
}

public enum ItemsLoadableState<T: Equatable>: LoadableState {
    
    public enum ItemsLoadableStateError: Error {
        case wrongStateForReadingItems
        case zeroItemsInLoadedState
    }
    
    public typealias ItemType = T
    
    case idle
    case loading
    case noContent
    case loaded(items: [ItemType])
    case refreshing(silent: Bool, items: [ItemType])
    case error(Error)
    
    public init(_ items: [ItemType]) {
        self = ItemsLoadableState.setStateForItems(items)
    }
    
    public var itemsCount: Int {
        switch self {
        case let .loaded(items):
            return items.count
        default:
            return 0
        }
    }
    
    public func items() throws -> [ItemType] {
        
        switch self {
        case let .loaded(items):
            guard items.isEmpty == false else {
                throw ItemsLoadableStateError.zeroItemsInLoadedState
            }
            
            return items
        default:
            throw ItemsLoadableStateError.wrongStateForReadingItems
        }
    }
    
    private static func setStateForItems(_ items: [ItemType]) -> ItemsLoadableState<ItemType> {
        if items.isEmpty {
            return .noContent
        } else {
            return .loaded(items: items)
        }
    }
}

extension ItemsLoadableState: Equatable {
    
    public static func ==(lhs: ItemsLoadableState<T>, rhs: ItemsLoadableState<T>) -> Bool {
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

public enum SectionatedItemsLoadableState<T: Equatable>: SectionatedLoadableState {
    
    public enum SectionatedItemsLoadableStateError: Error {
        case wrongStateForReadingSections
        case wrongStateForReadingItems
        case wrongStateForReadingItemsCount
        case zeroSectionsInLoadedState
        case zeroItemsInSectionAtLoadedState
        case sectionOutOfRange
    }
    
    public typealias ItemType = T
    
    case idle
    case loading
    case noContent
    case loaded(sections: [Section])
    case refreshing(silent: Bool, sections: [Section])
    case error(Error)
    
    public init(_ items: [Section]) {
        self = SectionatedItemsLoadableState.setStateForItems(items)
    }
    
    public var sectionsCount: Int {
        switch self {
        case let .loaded(sections):
            return sections.count
        default:
            return 0
        }
    }
    
    public func itemsSectionated() throws -> [Section] {
        switch self {
        case let .loaded(sections):
            guard sections.isEmpty == false else {
                throw SectionatedItemsLoadableStateError.zeroSectionsInLoadedState
            }
            return sections
        default:
            throw SectionatedItemsLoadableStateError.wrongStateForReadingSections
        }
    }
    
    public func allItems() throws -> [ItemType] {
        switch self {
        case let .loaded(sections):
            guard sections.isEmpty == false else {
                throw SectionatedItemsLoadableStateError.zeroSectionsInLoadedState
            }
            return sections.reduce([], +)
        default:
            throw SectionatedItemsLoadableStateError.wrongStateForReadingItems
        }
    }
    
    public func itemsCount(inSection section: Int) throws -> Int {
        switch self {
        case let .loaded(sections):
            guard sections.count > section else {
                throw SectionatedItemsLoadableStateError.sectionOutOfRange
            }
            return sections[section].count
        default:
            throw SectionatedItemsLoadableStateError.wrongStateForReadingItemsCount
        }
    }
    
    public func items(inSection section: Int) throws -> [ItemType] {
        switch self {
        case let .loaded(sections):
            guard sections.isEmpty == false else {
                throw SectionatedItemsLoadableStateError.zeroSectionsInLoadedState
            }
            guard sections.count > section else {
                throw SectionatedItemsLoadableStateError.sectionOutOfRange
            }
            return sections[section]
        default:
            throw SectionatedItemsLoadableStateError.wrongStateForReadingItems
        }
    }
    
    private static func setStateForItems(_ sections: [Section]) -> SectionatedItemsLoadableState<ItemType> {
        if sections.isEmpty {
            return .noContent
        } else {
            return .loaded(sections: sections)
        }
    }
    
}

extension SectionatedItemsLoadableState: Equatable {
    
    public static func ==(lhs: SectionatedItemsLoadableState<T>, rhs: SectionatedItemsLoadableState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.noContent, .noContent), (.error, .error):
            return true
        case (.refreshing(let lSilent, let lOldSections), .refreshing(let rSilent, let rOldSections)):
            return lSilent == rSilent // DIFFER TO IMPLEMENT
        case (.loaded(let lSections), .loaded(let rSections)):
            return false // DIFFER TO IMPLEMENT
        default:
            return false
        }
    }
}


public protocol StateLoadableTableViewDelegate: class {
    
    func shouldReload(tableView: UITableView!) -> Bool
    func shouldReload(collectionView: UICollectionView!) -> Bool
    
    var deletionAnimation: UITableViewRowAnimation { get } // check is available insertion animation for item ?
    var insertionAnimation: UITableViewRowAnimation { get } // check is available insertion animation for item ?
    
}

extension StateLoadableTableViewDelegate {
    
    public func shouldReload(tableView: UITableView!) -> Bool {
        return true
    }
    
    public func shouldReload(collectionView: UICollectionView!) -> Bool {
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


public protocol ItemsLoadableStateDiffer: class {
    
    //
    // If you want to provide custom states applier
    //
    
    func load<ItemType>(newState new: ItemsLoadableState<ItemType>, withOld old: ItemsLoadableState<ItemType>) -> ItemReloadingResult<ItemType>
    
}

public protocol SectionatedItemsLoadableStateDiffer: class {
    
    //
    // If you want to provide custom states applier
    //
    
    func load<ItemType>(newState new: SectionatedItemsLoadableState<ItemType>, withOld old: SectionatedItemsLoadableState<ItemType>) -> SectionatedItemsReloadingResult<ItemType>
    
}

public class Stefan<ItemType: Equatable>: NSObject, ItemsLoadableStateDiffer, StateLoadableTableViewDelegate {
    
    public weak var delegate: StateLoadableTableViewDelegate?
    
    public weak var statesDiffer: ItemsLoadableStateDiffer?
    
    public weak var placeholderPresenter: LoadableStatePlaceholderPresentable?
    
    private(set) weak var tableView: UITableView?
    private(set) weak var collectionView: UICollectionView?
    
    private(set) var state: ItemsLoadableState<ItemType> = .idle
    
    public override init() {
        super.init()
        statesDiffer = self
        delegate = self
    }
    
    public func load(newState: ItemsLoadableState<ItemType>) {
        let old = self.state
        self.state = newState
        
        guard let reloadingResult = statesDiffer?.load(newState: newState, withOld: old) else {
            assertionFailure("States differ not set when loading new state")
            return
        }
        
        switch reloadingResult {
        case .none:
            break
        case .placeholder:
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
        case let .items(oldItems: oldItems, newItems: newItems):
            
            if shouldReloadTableView() {
                // apply diff for table view
            }
            
            if shouldReloadCollectionView() {
                // apply diff for collection view
            }
            
        case let .placeholderAndItems(oldItems: oldItems, newItems: newItems):
            
            if shouldReloadTableView() {
                // apply diff for table view
            }
            
            if shouldReloadCollectionView() {
                // apply diff for collection view
            }
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
            
        case let .itemsAndPlaceholder(oldItems: oldItems, newItems: newItems):
            
            if shouldReloadTableView() {
                // apply diff for table view
            }
            
            if shouldReloadCollectionView() {
                // apply diff for collection view
            }
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
        }
    }
    
    private func shouldReloadTableView() -> Bool {
        guard let tableView = self.tableView else { return false }
        return delegate?.shouldReload(tableView: tableView) ?? true
    }
    
    private func shouldReloadCollectionView() -> Bool {
        guard let collectionView = self.collectionView else { return false }
        return delegate?.shouldReload(collectionView: collectionView) ?? true
    }
}

public class SectionatedStefan<ItemType: Equatable>: NSObject, SectionatedItemsLoadableStateDiffer, StateLoadableTableViewDelegate {
    
    public weak var delegate: StateLoadableTableViewDelegate?
    
    public weak var statesDiffer: SectionatedItemsLoadableStateDiffer?
    
    public weak var placeholderPresenter: LoadableStatePlaceholderPresentable?
    
    private(set) weak var tableView: UITableView?
    private(set) weak var collectionView: UICollectionView?
    
    private(set) var state: SectionatedItemsLoadableState<ItemType> = .idle
    
    public override init() {
        super.init()
        statesDiffer = self
        delegate = self
    }
    
    public func load(newState: SectionatedItemsLoadableState<ItemType>) {
        let old = self.state
        self.state = newState
        
        guard let reloadingResult = statesDiffer?.load(newState: newState, withOld: old) else {
            assertionFailure("States differ not set when loading new state")
            return
        }
        
        switch reloadingResult {
        case .none:
            break
        case .placeholder:
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
        case let .sections(oldSections: oldSections, newSections: newSections):
            
            if shouldReloadTableView() {
                // apply diff for table view
            }
            
            if shouldReloadCollectionView() {
                // apply diff for collection view
            }
            
        case let .placeholderAndSections(oldSections: oldSections, newSections: newSections):
            
            if shouldReloadTableView() {
                // apply diff for table view
            }
            
            if shouldReloadCollectionView() {
                // apply diff for collection view
            }
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
            
        case let .sectionsAndPlaceholder(oldSections: oldSections, newSections: newSections):
            
            if shouldReloadTableView() {
                // apply diff for table view
            }
            
            if shouldReloadCollectionView() {
                // apply diff for collection view
            }
            
            placeholderPresenter?.reloadPlaceholder(forState: newState)
            
        }
    }
    
    private func shouldReloadTableView() -> Bool {
        guard let tableView = self.tableView else { return false }
        return delegate?.shouldReload(tableView: tableView) ?? true
    }
    
    private func shouldReloadCollectionView() -> Bool {
        guard let collectionView = self.collectionView else { return false }
        return delegate?.shouldReload(collectionView: collectionView) ?? true
    }
}

public enum ItemReloadingResult<ItemType: Equatable> {
    
    // nothing to change on screen
    case none
    
    // only placeholder
    case placeholder
    
    // only collection
    case items(oldItems: [ItemType], newItems: [ItemType])
    
    // first placeholder then collection
    case placeholderAndItems(oldItems: [ItemType], newItems: [ItemType])
    
    // first collection then placeholder
    case itemsAndPlaceholder(oldItems: [ItemType], newItems: [ItemType])
    
}

public enum SectionatedItemsReloadingResult<ItemType: Equatable> {
    
    public typealias Section = SectionatedItemsLoadableState<ItemType>.Section
    
    // nothing to change on screen
    case none
    
    // only placeholder
    case placeholder
    
    // only collection
    case sections(oldSections: [Section], newSections: [Section])
    
    // first placeholder then collection
    case placeholderAndSections(oldSections: [Section], newSections: [Section])
    
    // first collection then placeholder
    case sectionsAndPlaceholder(oldSections: [Section], newSections: [Section])
    
}

extension ItemsLoadableStateDiffer {
    
    
    
    public func load<ItemType>(newState new: ItemsLoadableState<ItemType>, withOld old: ItemsLoadableState<ItemType>) -> ItemReloadingResult<ItemType> {
        
        switch(old, new) {
            
        case(.idle, _):
            
            if case let .loaded(newItems) = new {
                return .placeholderAndItems(oldItems: [], newItems: newItems)
            } else {
                return .placeholder
            }
            
        case (_, .idle):
            
            fatalError("Wrong change of state - idle is only for initial state")
            
        case (.loading, .loading), (.noContent, .noContent):
            
            return .none
            
        case (.loading, .noContent), (.loading, .error), (.error, .error), (.noContent, .error), (.error, .loading), (.noContent, .loading), (.error, .noContent):
            
            return .placeholder
            
        case (.loading, .loaded(let newItems)), (.error, .loaded(let newItems)), (.noContent, .loaded(let newItems)):
            
            return .placeholderAndItems(oldItems: [], newItems: newItems)
            
        case (.loading, .refreshing):
            
            fatalError("Wrong change of state - refreshing should not occur after loading")
            
        case (.loaded(let oldItems), .loaded(let newItems)):
            
            return .items(oldItems: oldItems, newItems: newItems)
            
        case (.refreshing(_ , let oldItems), .loaded(let newItems)):
            
            return .placeholderAndItems(oldItems: oldItems, newItems: newItems)
            
        case (.refreshing, .refreshing(let rSilent, _)), (.error, .refreshing(let rSilent, _)), (.noContent, .refreshing(let rSilent, _)):
            
            if rSilent {
                return .none
            } else {
                return .placeholder
            }
            
        case (.loaded(let oldItems), .refreshing(let rSilent, _)):
            
            if rSilent {
                return .none
            } else {
                return .itemsAndPlaceholder(oldItems: oldItems, newItems: [])
            }
            
        case (.refreshing, .loading):
            
            fatalError("Wrong change of state - loading should not occur after refreshing")
            
        case (.loaded, .loading):
            
            fatalError("Wrong change of state - loading should not occur after loaded")
            
        case (.loaded(let oldItems), .noContent), (.loaded(let oldItems), .error):
            
            return .itemsAndPlaceholder(oldItems: oldItems, newItems: [])
            
        case (.refreshing(let lSilent, let oldItems), .error), (.refreshing(let lSilent, let oldItems), .noContent):
            
            if lSilent {
                // table still displays items, need to hide them
                return .itemsAndPlaceholder(oldItems: oldItems, newItems: [])
            } else {
                return .placeholder
            }
        }
    }
}


extension SectionatedItemsLoadableStateDiffer {
    
    public func load<ItemType>(newState new: SectionatedItemsLoadableState<ItemType>, withOld old: SectionatedItemsLoadableState<ItemType>) -> SectionatedItemsReloadingResult<ItemType> {
        
        switch(old, new) {
            
        case(.idle, _):
            
            if case let .loaded(newSections) = new {
                return .placeholderAndSections(oldSections: [], newSections: newSections)
            } else {
                return .placeholder
            }
            
        case (_, .idle):
            
            fatalError("Wrong change of state - idle is only for initial state")
            
        case (.loading, .loading), (.noContent, .noContent):
            
            return .none
            
        case (.loading, .noContent), (.loading, .error), (.error, .error), (.noContent, .error), (.error, .loading), (.noContent, .loading), (.error, .noContent):
            
            return .placeholder
            
        case (.loading, .loaded(let newSections)), (.error, .loaded(let newSections)), (.noContent, .loaded(let newSections)):
            
            return .placeholderAndSections(oldSections: [], newSections: newSections)
            
        case (.loading, .refreshing):
            
            fatalError("Wrong change of state - refreshing should not occur after loading")
            
        case (.loaded(let oldSections), .loaded(let newSections)):
            
            return .sections(oldSections: oldSections, newSections: newSections)
            
        case (.refreshing(_ , let oldSections), .loaded(let newSections)):
            
            return .placeholderAndSections(oldSections: oldSections, newSections: newSections)
            
        case (.refreshing, .refreshing(let rSilent, _)), (.error, .refreshing(let rSilent, _)), (.noContent, .refreshing(let rSilent, _)):
            
            if rSilent {
                return .none
            } else {
                return .placeholder
            }
            
        case (.loaded(let oldSections), .refreshing(let rSilent, _)):
            
            if rSilent {
                return .none
            } else {
                return .sectionsAndPlaceholder(oldSections: oldSections, newSections: [])
            }
            
        case (.refreshing, .loading):
            
            fatalError("Wrong change of state - loading should not occur after refreshing")
            
        case (.loaded, .loading):
            
            fatalError("Wrong change of state - loading should not occur after loaded")
            
        case (.loaded(let oldSections), .noContent), (.loaded(let oldSections), .error):
            
            return .sectionsAndPlaceholder(oldSections: oldSections, newSections: [])
            
        case (.refreshing(let lSilent, let oldSections), .error), (.refreshing(let lSilent, let oldSections), .noContent):
            
            if lSilent {
                // table still displays sections, need to hide them
                return .sectionsAndPlaceholder(oldSections: oldSections, newSections: [])
            } else {
                return .placeholder
            }
        }
    }
}


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

public protocol ItemsLoadableStateBindable {
    
    func bind<ItemType>(withState state: ItemsLoadableState<ItemType>)
}

public protocol SectionatedItemsLoadableStateBindable {
    
    func bind<ItemType>(withState state: SectionatedItemsLoadableState<ItemType>)
}


open class LoadableStatePlaceholderView: UIView {
    
    // setup functions to prepare labels, views etc ...
    
    //
    // Function for setting up your custom view based on table view
    // Default implementation is empty
    //
    
    public func setup(withTableView tableView: UITableView!) {
        
    }
    
    //
    // Function for setting up your custom view based on collection view
    // Default implementation is empty
    //
    
    public func setup(withCollectionView collectionView: UICollectionView!) {
        
    }
}

public protocol LoadableStatePlaceholderDefaultViewDataSource: class {
    
    // provide titles / subtitle / image for states ...
    
    // we can develop 2 data sources for default implementation or
    // do something like :
    
    // - title(forItemsLoadableState ...
    // - title(forSectionatedItemsLoadableState ...
}

public final class LoadableStatePlaceholderDefaultView: LoadableStatePlaceholderView, ItemsLoadableStateBindable, SectionatedItemsLoadableStateBindable {
    
    //
    // Use dataSource to provide title / subtitle or image for states
    //
    
    var dataSource: LoadableStatePlaceholderDefaultViewDataSource?
    
    //
    //
    //
    
    public func bind<ItemType>(withState state: ItemsLoadableState<ItemType>) {
        
    }
    
    //
    //
    //
    
    public func bind<T>(withState state: SectionatedItemsLoadableState<T>) {
        
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
