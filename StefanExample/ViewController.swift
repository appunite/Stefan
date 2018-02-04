//
//  ViewController.swift
//  StefanExample
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import UIKit
import Stefan_iOS

class ViewController: UITableViewController, LoadableStatePlaceholderPresentable {
        
    weak var placeholderView: LoadableStatePlaceholderView? {
        didSet {
            guard let defaultView = placeholderView as? LoadableStatePlaceholderDefaultView else {
                return
            }
            
            defaultView.titleLabel.textColor = .black
            defaultView.subtitleLabel.textColor = .black
            defaultView.activityIndicator.color = .black
        }
    }
    
    var stefan = Stefan<Fruit>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stefan.placeholderPresenter = self
        stefan.reloadableView = tableView

        stefan.load(newState: .loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { [unowned self] in
            self.stefan.load(newState: .loaded(items: FruitStorage.bigFruits))
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: { [unowned self] in
            let currentItems = (try? self.stefan.state.items()) ?? []
            self.stefan.load(newState: .refreshing(silent: true, items: currentItems))
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: { [unowned self] in
            self.stefan.load(newState: .loaded(items: FruitStorage.mediumFruits))
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: { [unowned self] in
            self.stefan.load(newState: .loaded(items: FruitStorage.mediumFruits))
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: { [unowned self] in
            self.stefan.load(newState: .noContent)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0, execute: { [unowned self] in
            let currentItems = (try? self.stefan.state.items()) ?? []
            self.stefan.load(newState: .refreshing(silent: false, items: currentItems))
        })
        
        tableView.tableFooterView = UIView()
    }
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stefan.state.itemsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        do {
            let fruits = try stefan.state.items()
            let cell = tableView.dequeueReusableCell(withIdentifier: "FruitTableViewCell") as! FruitTableViewCell //swiftlint:disable:this force_cast
            cell.bind(withFruit: fruits[indexPath.row])
            return cell
        } catch let error {
            assertionFailure(error.localizedDescription)
            return UITableViewCell()
        }
    }
}
