//
//  StefanDifferTests.swift
//  StefanTests
//
//  Created by Szymon Mrozek on 04.02.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import XCTest
import DifferenceKit
@testable import Stefan

extension Array where Element: Differentiable {
    public static func == (lhs: [Element], rhs: [Element]) -> Bool {
        var equal = true
        for (l, r) in zip(lhs, rhs) {
            guard l.isContentEqual(to: r) == false else { continue }
            equal = false
            break
        }
        return equal
    }
}

extension ItemReloadingResult: Equatable {
    public static func == (lhs: ItemReloadingResult<ItemType>, rhs: ItemReloadingResult<ItemType>) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none), (.placeholder, .placeholder): return true
        case let (.items(lOld, lNew), .items(rOld, rNew)): return rOld == lOld && lNew == rNew
        case let (.placeholderAndItems(lOld, lNew), .placeholderAndItems(rOld, rNew)): return rOld == lOld && lNew == rNew
        case let (.itemsAndPlaceholder(lOld, lNew), .itemsAndPlaceholder(rOld, rNew)): return rOld == lOld && lNew == rNew
        default: return false
        }
    }
}

class StefanDifferTests: XCTestCase {
    
    enum StefanDifferTestsError: Error {
        case someError
    }
    
    let sut = Stefan<Fruit>(reloadingType: .basic)
    var old: ItemsLoadableState<Fruit>!
    var new: ItemsLoadableState<Fruit>!
    
    override func setUp() {
        super.setUp()
    }

    func testFromIdleToLoaded() {
        old = .idle
        new = .loaded(items: FruitStorage.bigFruits)
        
        let diffResult = sut.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult.placeholderAndItems(oldItems: [], newItems: FruitStorage.bigFruits)
        
        XCTAssertEqual(expectedResult, diffResult)

    }
    
    func testFromIdleToOther() {
        old = .idle
        new = .loading
        
        var diffResult = sut.load(newState: new, withOld: old)
        var expectedResult = ItemReloadingResult<Fruit>.placeholder
        
        XCTAssertEqual(expectedResult, diffResult)
        
        old = .idle
        new = .noContent
        
        diffResult = sut.load(newState: new, withOld: old)
        expectedResult = ItemReloadingResult<Fruit>.placeholder
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromLoadingToLoading() {
        old = .loading
        new = .loading
        
        let diffResult = sut.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.none
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromNoContentToNoContent() {
        old = .noContent
        new = .noContent
        
        let diffResult = sut.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.none
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromNoContentToLoading() {
        old = .noContent
        new = .loading
        
        let diffResult = sut.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.placeholder
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromLoadingToNoContent() {
        old = .loading
        new = .noContent
        
        let diffResult = sut.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.placeholder
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromErrorToNoContent() {
        old = .loading
        new = .noContent
        
        let diffResult = sut.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.placeholder
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromLoadingToLoaded() {
        old = .loading
        new = .loaded(items: FruitStorage.bigFruits)

        let diffResult = sut.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult.placeholderAndItems(oldItems: [], newItems: FruitStorage.bigFruits)
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromNoContentToLoaded() {
        old = .noContent
        new = .loaded(items: FruitStorage.bigFruits)

        let diffResult = sut.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult.placeholderAndItems(oldItems: [], newItems: FruitStorage.bigFruits)
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromErrorToLoaded() {
        old = .error(StefanDifferTestsError.someError)
        new = .loaded(items: FruitStorage.bigFruits)

        let diffResult = sut.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult.placeholderAndItems(oldItems: [], newItems: FruitStorage.bigFruits)
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromLoadedToLoaded() {
        old = .loaded(items: FruitStorage.mediumFruits)
        new = .loaded(items: FruitStorage.bigFruits)
        
        let diffResult = sut.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult.items(oldItems: FruitStorage.mediumFruits, newItems: FruitStorage.bigFruits)
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testFromLoadedToNoContent() {
        old = .loaded(items: FruitStorage.bigFruits)
        new = .noContent
        
        let diffResult = sut.load(newState: new, withOld: old)
        let expectedResult = ItemReloadingResult<Fruit>.itemsAndPlaceholder(oldItems: FruitStorage.bigFruits, newItems: [])
        
        XCTAssertEqual(expectedResult, diffResult)
    }
    
    func testDifferentResults() {
        // because of coverage
        old = .idle
        new = .noContent
        
        let diffResult = sut.load(newState: new, withOld: old)
        let wrongResult = ItemReloadingResult<Fruit>.none
        
        XCTAssertNotEqual(wrongResult, diffResult)
    }
    
}

