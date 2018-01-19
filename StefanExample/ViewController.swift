//
//  ViewController.swift
//  StefanExample
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import UIKit
import Stefan

class ViewController: UIViewController, LoadableStatePlaceholderPresentable {
    
    @IBOutlet weak var tableView: UITableView!
    
    var placeholderView: LoadableStatePlaceholderView!
    var stefan = Stefan<Fruit>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPlaceholderView(to: self.view)
        stefan.placeholderPresenter = self
        stefan.reloadableView = tableView

        stefan.load(newState: .loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 , execute: { [unowned self] in
            self.stefan.load(newState: .loaded(items: FruitStorage.bigFruits))
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: { [unowned self] in
            let currentItems = (try? self.stefan.getState().items()) ?? []
            self.stefan.load(newState: .refreshing(silent: true, items: currentItems))
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0 , execute: { [unowned self] in
            self.stefan.load(newState: .loaded(items: FruitStorage.mediumFruits))
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0 , execute: { [unowned self] in
            self.stefan.load(newState: .loaded(items: FruitStorage.mediumFruits))
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0 , execute: { [unowned self] in
            self.stefan.load(newState: .noContent)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0 , execute: { [unowned self] in
            let currentItems = (try? self.stefan.getState().items()) ?? []
            self.stefan.load(newState: .refreshing(silent: false, items: currentItems))
        })

        
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stefan.getState().itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        do {
            let fruits = try stefan.getState().items()
            let cell = tableView.dequeueReusableCell(withIdentifier: "FruitTableViewCell") as! FruitTableViewCell
            cell.bind(withFruit: fruits[indexPath.row])
            return cell
        } catch (let error) {
            assertionFailure(error.localizedDescription)
            return UITableViewCell()
        }
    }
}

