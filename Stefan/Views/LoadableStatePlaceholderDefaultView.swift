//
//  LoadableStatePlaceholderDefaultView.swift
//  Stefan
//
//  Created by Szymon Mrozek on 16.01.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

import UIKit

public final class LoadableStatePlaceholderDefaultView: LoadableStatePlaceholderView, ItemsLoadableStateBindable, LoadableStatePlaceholderDefaultViewDataSource {
    ///
    /// Metrics should be provided in init
    ///
    public struct Metrics {
        public let activityIndicatorSize: CGSize
        public let spacing: CGFloat
        public let verticalOffset: CGFloat
        
        public init(activityIndicatorSize: CGSize = CGSize(width: 40.0, height: 40.0), spacing: CGFloat = 20.0, verticalOffset: CGFloat = 0.0) {
            self.activityIndicatorSize = activityIndicatorSize
            self.spacing = spacing
            self.verticalOffset = verticalOffset
        }
    }
    
    // TO DO: - Dynamically changable offset
    
    let metrics: Metrics
    
    ///
    /// Use dataSource to provide title / subtitle or image for states
    ///
    
    weak var dataSource: LoadableStatePlaceholderDefaultViewDataSource?
    
    ///
    /// Labels / Activity Indicator can be modified directly (ex. font, colors, etc.)
    ///
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textColor = .white
        
        return label
    }()
    
    public lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textColor = .white
        
        return label
    }()
    
    public lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(origin: CGPoint.zero, size: metrics.activityIndicatorSize)
        activityIndicator.style = .whiteLarge
        
        return activityIndicator
    }()
    
    ///
    /// By default initializes with 20.0 spacing, and no offset
    ///
    
    public init(metrics: Metrics = Metrics()) {
        self.metrics = metrics
        super.init(frame: CGRect.zero)
        dataSource = self
    }
    
    public override func setupView() {
        let stackView = UIStackView()
        
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: metrics.verticalOffset)
            ]
        
        NSLayoutConstraint.activate(constraints)
        
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = metrics.spacing
        stackView.axis = .vertical
        
        stackView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000.0), for: .vertical)
        stackView.setContentHuggingPriority(UILayoutPriority(rawValue: 1000.0), for: .vertical)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(activityIndicator)
    }
    ///
    /// This view should not be loaded in storyboard / xib
    ///
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    /// Binds ItemsLoadableState with labels / activityIndicator ...
    ///
    public func bind<ItemType>(withState state: ItemsLoadableState<ItemType>) {
        self.titleLabel.text = dataSource?.title(forState: state)
        self.subtitleLabel.text = dataSource?.subtitle(forState: state)
        
        if dataSource?.shouldIndicatorAnimate(forState: state) ?? false {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
}
