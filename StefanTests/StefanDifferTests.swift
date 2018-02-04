//
//  StefanDifferTests.swift
//  StefanTests
//
//  Created by Szymon Mrozek on 04.02.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import XCTest

@testable import Stefan_iOS

class StefanDifferTests: XCTestCase, ItemsLoadableStateDiffer {
    
    enum StefanDifferTestsError: Error {
        case someError
    }
    
    var old: ItemsLoadableState<Fruit>!
    var new: ItemsLoadableState<Fruit>!
    
    override func setUp() {
        super.setUp()
    }

    func testFromIdleToLoaded() {
        old = .idle
        new = .loaded(items: FruitStorage.bigFruits)
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult.placeholderAndItems(oldItems: [], newItems: FruitStorage.bigFruits)
        
        XCTAssertEqual(expectedResult, diffResult)

    }
    
    func testFromIdleToOther() {
        old = .idle
        new = .loading
        
        var diffResult = self.load(newState: new, withOld: old)
        var expectedResult = ItemReloadingResult<Fruit>.placeholder
        
        XCTAssertEqual(expectedResult, diffResult)
        
        old = .idle
        new = .noContent
        
        diffResult = self.load(newState: new, withOld: old)
        expectedResult = ItemReloadingResult<Fruit>.placeholder
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    
    func testFromIdleToIdle() {
        old = .idle
        new = .idle
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.none
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromLoadingToLoading() {
        old = .loading
        new = .loading
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.none
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromNoContentToNoContent() {
        old = .noContent
        new = .noContent
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.none
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromNoContentToLoading() {
        old = .noContent
        new = .loading
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.placeholder
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromLoadingToNoContent() {
        old = .loading
        new = .noContent
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.placeholder
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromErrorToNoContent() {
        old = .loading
        new = .noContent
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.placeholder
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromLoadingToLoaded() {
        old = .loading
        new = .loaded(items: FruitStorage.bigFruits)

        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult.placeholderAndItems(oldItems: [], newItems: FruitStorage.bigFruits)
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromNoContentToLoaded() {
        old = .noContent
        new = .loaded(items: FruitStorage.bigFruits)

        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult.placeholderAndItems(oldItems: [], newItems: FruitStorage.bigFruits)
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromErrorToLoaded() {
        old = .error(StefanDifferTestsError.someError)
        new = .loaded(items: FruitStorage.bigFruits)

        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult.placeholderAndItems(oldItems: [], newItems: FruitStorage.bigFruits)
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromLoadedToLoaded() {
        old = .loaded(items: FruitStorage.mediumFruits)
        new = .loaded(items: FruitStorage.bigFruits)
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult.items(oldItems: FruitStorage.mediumFruits, newItems: FruitStorage.bigFruits)
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromRefreshingToLoaded() {
        old = .refreshing(silent: false, items: FruitStorage.mediumFruits)
        new = .loaded(items: FruitStorage.bigFruits)
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult.placeholderAndItems(oldItems: FruitStorage.mediumFruits, newItems: FruitStorage.bigFruits)
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromNoContentToSilentRefresh() {
        old = .noContent
        new = .refreshing(silent: true, items: FruitStorage.mediumFruits)
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.none
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromNoContentToNonSilentRefresh() {
        old = .noContent
        new = .refreshing(silent: false, items: FruitStorage.mediumFruits)
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.placeholder
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromLoadedToSilentRefresh() {
        old = .loaded(items: FruitStorage.bigFruits)
        new = .refreshing(silent: true, items: FruitStorage.bigFruits)
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.none
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromLoadedToNonSilentRefresh() {
        old = .loaded(items: FruitStorage.bigFruits)
        new = .refreshing(silent: false, items: FruitStorage.bigFruits)
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.itemsAndPlaceholder(oldItems: FruitStorage.bigFruits, newItems: [])
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromLoadedToNoContent() {
        old = .loaded(items: FruitStorage.bigFruits)
        new = .noContent
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.itemsAndPlaceholder(oldItems: FruitStorage.bigFruits, newItems: [])
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromSilentRefreshToNoContent() {
        old = .refreshing(silent: true, items: FruitStorage.bigFruits)
        new = .noContent
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.itemsAndPlaceholder(oldItems: FruitStorage.bigFruits, newItems: [])
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromNonSilentRefreshToNoContent() {
        old = .refreshing(silent: false, items: FruitStorage.bigFruits)
        new = .noContent
        
        let diffResult = self.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.placeholder
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testDifferentResults() {
        // because of coverage
        old = .idle
        new = .noContent
        
        let diffResult = self.load(newState: new, withOld: old)
        let wrongResult = ItemReloadingResult<Fruit>.none
        
        XCTAssertNotEqual(wrongResult, diffResult)
    }
    
}

