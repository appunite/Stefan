//
//  FruitTableViewCell.swift
//  StefanExample
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import UIKit

class FruitTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(withFruit fruit: Fruit) {
        
        self.nameLabel.text = fruit.name
        
        switch fruit.size {
        case .small:
            self.sizeLabel.text = "small"
        case .medium:
            self.sizeLabel.text = "medium"
        case .big:
            self.sizeLabel.text = "big"
        }
    }

}
