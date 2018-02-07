//
//  Comments.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

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
