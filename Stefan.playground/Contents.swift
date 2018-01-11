import Foundation

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

public enum PlainLoadableState<T>: PlainLoadableStateType {
    
    public typealias ItemType = T
    
    case idle
    case loading
    case noContent
    case loaded(items: [ItemType])
    case refreshing(silent: Bool)
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


public enum SectionatedLoadableState<T>: SectionatedLoadableStateType {
    
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
