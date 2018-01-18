//
//  Fruit.swift
//  StefanExample
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

enum FruitSize {
    
    case small
    case medium
    case big
}

struct Fruit {
    
    let name: String
    let size: FruitSize
    
    init(name: String, size: FruitSize) {
        self.name = name
        self.size = size
    }

}

extension Fruit: Equatable {
    
    static func ==(lhs: Fruit, rhs: Fruit) -> Bool {
        return lhs.name == rhs.name &&
               lhs.size == rhs.size
    }

}
