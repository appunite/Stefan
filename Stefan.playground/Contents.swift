import Foundation

//////////////////////
// Stefan
/////////////////////

public protocol LoadableStateType {
    associatedtype ItemType
}

public enum LoadableState<T> {
    typealias ItemType = T
    
    case idle
    case loading
    case loaded(items: [T])
    case refreshing
    case noContent
    case error(Error)
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
