//
//  LoadableStatePlaceholderDefaultView.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import Foundation

public final class LoadableStatePlaceholderDefaultView: LoadableStatePlaceholderView, ItemsLoadableStateBindable, SectionatedItemsLoadableStateBindable, LoadableStatePlaceholderDefaultViewDataSource {
    
    //
    // Use dataSource to provide title / subtitle or image for states
    //
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        
        return label
    }()
    
    public lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        
        return label
    }()
    
    public lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        
        return activityIndicator
    }()
    
    public override func setupView() {
        let stackView = UIStackView()
        
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(activityIndicator)
    }
    
    
    var dataSource: LoadableStatePlaceholderDefaultViewDataSource?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        dataSource = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    //
    //
    
    public func bind<ItemType>(withState state: ItemsLoadableState<ItemType>) {
        self.titleLabel.text = dataSource?.title(forState: state)
        self.subtitleLabel.text = dataSource?.subtitle(forState: state)
        
        if dataSource?.shouldIndicatorAnimate(forState: state) ?? false {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    
    //
    //
    //
    
    public func bind<T>(withState state: SectionatedItemsLoadableState<T>) {
        self.titleLabel.text = dataSource?.title(forState: state)
        self.subtitleLabel.text = dataSource?.subtitle(forState: state)
        
        if dataSource?.shouldIndicatorAnimate(forState: state) ?? false {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
}
