//
//  ItemsLoadableStateTests.swift
//  StefanTests
//
//  Created by Szymon Mrozek on 04.02.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import XCTest

@testable import Stefan_iOS

class ItemsLoadableStateTests: XCTestCase {
    
    enum TestError: Error {
        case someError
    }
    
    override func setUp() {
        super.setUp()
    }
    
    public func testItemsCount() {
        
        let items = FruitStorage.smallFruits
        
        var state = ItemsLoadableState<Fruit>.loaded(items: items)

        let notEmptyItemsCount = items.count
        
        XCTAssertEqual(state.itemsCount, notEmptyItemsCount)
        
        state = .noContent
        
        XCTAssertEqual(state.itemsCount, 0)
    }
    
    public func testGrabbingItemsInLoadedStateCorrectly() {
        
        let state = ItemsLoadableState<Fruit>.loaded(items: FruitStorage.bigFruits)
        
        do {
            _ = try state.items()
        } catch {
            XCTFail()
        }
    }
    
    public func testGrabbingItemsInLoadedStateWith0Items() {
        
        let state = ItemsLoadableState<Fruit>.loaded(items: [])
        
        do {
            _ = try state.items()
            XCTFail()
        } catch let error {
            guard let stateError = error as? ItemsLoadableState<Fruit>.ItemsLoadableStateError, stateError == ItemsLoadableState<Fruit>.ItemsLoadableStateError.zeroItemsInLoadedState else {
                XCTFail()
                return
            }
        }
    }
    
    public func testGrabbingItemsInRefreshingStateCorrectly() {
        
        let state = ItemsLoadableState<Fruit>.refreshing(silent: true, items: FruitStorage.mediumFruits)
        
        do {
            _ = try state.items()
        } catch {
            XCTFail()
        }
    }
    
    public func testGrabbingItemsInSilentRefreshState() {
        
        let state = ItemsLoadableState<Fruit>.refreshing(silent: false, items: FruitStorage.bigFruits)
        
        do {
            _ = try state.items()
            XCTFail()
        } catch let error {
            guard let stateError = error as? ItemsLoadableState<Fruit>.ItemsLoadableStateError, stateError == ItemsLoadableState<Fruit>.ItemsLoadableStateError.wrongStateForReadingItems else {
                XCTFail()
                return
            }
        }
    }
    
    public func testGrabbingItemsInWrongStates() {
        
        let idleState = ItemsLoadableState<Fruit>.idle
        let noContentState = ItemsLoadableState<Fruit>.noContent
        let loadingState = ItemsLoadableState<Fruit>.loading
        
        do {
            _ = try idleState.items()
            _ = try noContentState.items()
            _ = try loadingState.items()
            XCTFail()
        } catch let error {
            guard let stateError = error as? ItemsLoadableState<Fruit>.ItemsLoadableStateError, stateError == ItemsLoadableState<Fruit>.ItemsLoadableStateError.wrongStateForReadingItems else {
                XCTFail()
                return
            }
        }
    }
    
    public func testInitWithItemsExplicity() {
        
        let items = FruitStorage.mediumFruits

        let state = ItemsLoadableState<Fruit>(items)
        
        XCTAssertEqual(state, ItemsLoadableState<Fruit>.loaded(items: items))
    }

    public func testInitWithNoItems() {
        
        let state = ItemsLoadableState<Fruit>([])
        XCTAssertEqual(state, ItemsLoadableState<Fruit>.noContent)
    }
    
    public func testStatesComparingNoItems() {
        
        var lState = ItemsLoadableState<Fruit>.idle
        var rState = ItemsLoadableState<Fruit>.idle
        XCTAssertEqual(lState, rState)


        lState = ItemsLoadableState<Fruit>.loading
        rState = ItemsLoadableState<Fruit>.loading
        XCTAssertEqual(lState, rState)

        
        lState = ItemsLoadableState<Fruit>.noContent
        rState = ItemsLoadableState<Fruit>.noContent
        XCTAssertEqual(lState, rState)

        
        lState = ItemsLoadableState<Fruit>.error(TestError.someError)
        rState = ItemsLoadableState<Fruit>.error(TestError.someError)
        XCTAssertEqual(lState, rState)

        
        lState = ItemsLoadableState<Fruit>.idle
        rState = ItemsLoadableState<Fruit>.loading
        XCTAssertNotEqual(lState, rState)

    }
    
    public func testStatesComparingRefreshing() {
        
        let items = FruitStorage.smallFruits
        
        var lState = ItemsLoadableState<Fruit>.refreshing(silent: true, items: items)
        var rState = ItemsLoadableState<Fruit>.refreshing(silent: true, items: items)
        XCTAssertEqual(lState, rState)

        
        lState = ItemsLoadableState<Fruit>.refreshing(silent: false, items: items)
        rState = ItemsLoadableState<Fruit>.refreshing(silent: false, items: items)
        XCTAssertEqual(lState, rState)

        
        lState = ItemsLoadableState<Fruit>.refreshing(silent: false, items: items)
        rState = ItemsLoadableState<Fruit>.refreshing(silent: true, items: items)
        XCTAssertNotEqual(lState, rState)

        
        lState = ItemsLoadableState<Fruit>.refreshing(silent: true, items: [])
        rState = ItemsLoadableState<Fruit>.refreshing(silent: true, items: items)
        XCTAssertNotEqual(lState, rState)

    }
    
    public func testStatesComparingLoaded() {
        
        let items = FruitStorage.smallFruits
        
        var lState = ItemsLoadableState<Fruit>.loaded(items: items)
        var rState = ItemsLoadableState<Fruit>.loaded(items: items)
        XCTAssertEqual(lState, rState)

        
        lState = ItemsLoadableState<Fruit>.loaded(items: [])
        rState = ItemsLoadableState<Fruit>.loaded(items: items)
        XCTAssertNotEqual(lState, rState)

        
        lState = ItemsLoadableState<Fruit>.loaded(items: items)
        rState = ItemsLoadableState<Fruit>.loaded(items: items + FruitStorage.mediumFruits)
        XCTAssertNotEqual(lState, rState)
        
    }
    
}
