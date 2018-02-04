//
//  FruitStorage.swift
//  StefanTests
//
//  Created by Szymon Mrozek on 04.02.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

struct FruitStorage {
    
    static var smallFruits: [Fruit] {
        let fruitSize: FruitSize = .small
        
        return [
            Fruit(name: "Blackberry", size: fruitSize),
            Fruit(name: "Grape", size: fruitSize),
            Fruit(name: "Blackcurrant", size: fruitSize),
            Fruit(name: "Gooseberry", size: fruitSize),
            Fruit(name: "Raspberry", size: fruitSize),
            Fruit(name: "Strawberry", size: fruitSize),
            Fruit(name: "Cherry", size: fruitSize),
            Fruit(name: "Plum", size: fruitSize)
        ]
    }
    
    static var mediumFruits: [Fruit] {
        let fruitSize: FruitSize = .medium
        
        return [
            Fruit(name: "Apple", size: fruitSize),
            Fruit(name: "Peach", size: fruitSize),
            Fruit(name: "Pear", size: fruitSize),
            Fruit(name: "Kiwi", size: fruitSize),
            Fruit(name: "Maracuja", size: fruitSize),
            Fruit(name: "Guava", size: fruitSize)
        ]
    }
    
    static var bigFruits: [Fruit] {
        let fruitSize: FruitSize = .big
        
        return [
            Fruit(name: "Banana", size: fruitSize),
            Fruit(name: "Mango", size: fruitSize),
            Fruit(name: "Pineapple", size: fruitSize),
            Fruit(name: "Grapefruit", size: fruitSize),
            Fruit(name: "Watermelon", size: fruitSize),
            Fruit(name: "Coconut", size: fruitSize),
            Fruit(name: "Papaya", size: fruitSize)
        ]
    }
    
}
