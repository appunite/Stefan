//
//  StefanTests.swift
//  StefanTests
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import XCTest
@testable import Stefan_iOS

class StefanTests: XCTestCase {
    
    var stefan = Stefan<Fruit>()
    
    var firstState: ItemsLoadableState<Fruit>!
    var secondState: ItemsLoadableState<Fruit>!
    
    let testController = StefanTestController()
    
    override func setUp() {
        super.setUp()
        stefan = Stefan<Fruit>()
        stefan.placeholderPresenter = testController
        stefan.reloadableView = testController.tableView
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoadStateNoneResult() {
        
        // Placeholder on screen
        
        firstState = .noContent
        secondState = .noContent

        stefan.load(newState: firstState)
        XCTAssertEqual(firstState, stefan.state)
        stefan.load(newState: secondState)
        XCTAssertEqual(secondState, stefan.state)
        
        // Removing placeholder if needed
        
        firstState = .loaded(items: FruitStorage.mediumFruits)
        secondState = .loaded(items: FruitStorage.mediumFruits)
        
        stefan.load(newState: firstState)
        XCTAssertEqual(firstState, stefan.state)
        stefan.load(newState: secondState)
        XCTAssertEqual(secondState, stefan.state)
    }
    
    func testLoadStatePlaceholderResult() {
        
        firstState = .noContent
        secondState = .loading
        
        stefan.load(newState: firstState)
        XCTAssertEqual(firstState, stefan.state)
        stefan.load(newState: secondState)
        XCTAssertEqual(secondState, stefan.state)
    }
    
    func testLoadStateItemsResult() {
        firstState = .loaded(items: FruitStorage.mediumFruits)
        secondState = .loaded(items: FruitStorage.bigFruits)
        
        stefan.load(newState: firstState)
        XCTAssertEqual(firstState, stefan.state)
        stefan.load(newState: secondState)
        XCTAssertEqual(secondState, stefan.state)
    }
    
    func testLoadStatePlaceholderAndItemsResult() {
        // Remove placeholder if needed
        firstState = .noContent
        secondState = .loaded(items: FruitStorage.bigFruits)
        
        stefan.load(newState: firstState)
        XCTAssertEqual(firstState, stefan.state)
        stefan.load(newState: secondState)
        XCTAssertEqual(secondState, stefan.state)
        
        // Test with adding placeholder if needed
        stefan.shouldDisplayPlaceholder = { _ in return true }
        firstState = .noContent
        secondState = .loaded(items: FruitStorage.bigFruits)
        
        stefan.load(newState: firstState)
        XCTAssertEqual(firstState, stefan.state)
        stefan.load(newState: secondState)
        XCTAssertEqual(secondState, stefan.state)

    }
    
    func testLoadStateItemsAndPlaceholderResult() {
        // Add placeholder if needed
        firstState = .loaded(items: FruitStorage.mediumFruits)
        secondState = .noContent
        
        stefan.load(newState: firstState)
        XCTAssertEqual(firstState, stefan.state)
        stefan.load(newState: secondState)
        XCTAssertEqual(secondState, stefan.state)
        
        // Test with removing placeholder if needed
        stefan.shouldDisplayPlaceholder = { _ in return false }
        firstState = .loaded(items: FruitStorage.mediumFruits)
        secondState = .noContent
        
        stefan.load(newState: firstState)
        XCTAssertEqual(firstState, stefan.state)
        stefan.load(newState: secondState)
        XCTAssertEqual(secondState, stefan.state)
    }
    
    func testShouldReloadClosure() {
        
        let shouldReloadAsked = expectation(description: "Closure shouldReload did call")

        firstState = .loaded(items: FruitStorage.mediumFruits)
        stefan.load(newState: firstState)
        
        stefan.shouldReload = { _ in
            shouldReloadAsked.fulfill()
            return true
        }
        // TEST
        secondState = .noContent
        stefan.load(newState: secondState)
        
        wait(for: [shouldReloadAsked], timeout: 1.0)
    }
    
    func testDidChangeStateClosure() {
        
        let didChangeStateCalled = expectation(description: "Did change state closure called")
        
        firstState = .loaded(items: FruitStorage.mediumFruits)
        stefan.load(newState: firstState)

        stefan.didChangeState = { _ in
            didChangeStateCalled.fulfill()
        }
        
        // TEST
        secondState = .noContent
        stefan.load(newState: secondState)
        wait(for: [didChangeStateCalled], timeout: 1.0)
    }
    
    func testShouldDisplayPlaceholderClosure() {
        
        let shouldDisplayPlaceholderCalled = expectation(description: "Should display placeholder closure called")
        
        firstState = .loaded(items: FruitStorage.mediumFruits)
        stefan.load(newState: firstState)
        
        stefan.shouldDisplayPlaceholder = { _ in
            shouldDisplayPlaceholderCalled.fulfill()
            return true
        }
        
        // TEST
        secondState = .noContent
        stefan.load(newState: secondState)
        wait(for: [shouldDisplayPlaceholderCalled], timeout: 1.0)
    }
    
}
