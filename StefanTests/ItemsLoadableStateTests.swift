//
//  ItemsLoadableStateTests.swift
//  StefanTests
//
//  Created by Szymon Mrozek on 04.02.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import XCTest

@testable import Stefan

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
        let items = state.items()
        XCTAssertTrue(items == FruitStorage.bigFruits)
    }
    
    public func testGrabbingItemsInWrongStates() {
        let idleState = ItemsLoadableState<Fruit>.idle
        let noContentState = ItemsLoadableState<Fruit>.noContent
        let loadingState = ItemsLoadableState<Fruit>.loading
        
        XCTAssertTrue([] == idleState.items())
        XCTAssertTrue([] == noContentState.items())
        XCTAssertTrue([] == loadingState.items())
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
}

extension ItemsLoadableState: Equatable {
    public static func == (lhs: ItemsLoadableState<T>, rhs: ItemsLoadableState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.noContent, .noContent), (.error, .error):
            return true
        case let (.loaded(lItems), .loaded(rItems)):
            return lItems == rItems
        default: return false
        }
    }
}
