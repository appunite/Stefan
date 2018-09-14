//
//  Fruit.swift
//  StefanTests
//
//  Created by Szymon Mrozek on 04.02.2018.
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
    var differenceIdentifier: Fruit.DifferenceIdentifier {
        return name.hashValue + size.hashValue
    }
    
    func isContentEqual(to source: Fruit) -> Bool {
        return self.name = source.name && self.size == source.size
    }
}
