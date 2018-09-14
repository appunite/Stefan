//
//  Fruit.swift
//  StefanExample
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation
import DifferenceKit

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

extension Fruit: Differentiable {
    typealias DifferenceIdentifier = Int
    
    var differenceIdentifier: Int {
        return name.hashValue
    }

    func isContentEqual(to source: Fruit) -> Bool {
        return name == source.name && size == source.size
    }
}
