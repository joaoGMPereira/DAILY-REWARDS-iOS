//
//  ChallengeButtonsView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 16/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import CollectionKit
import JewFeatures

public class ChallengeButtonsView: UIView {
    public var collectionView = CollectionView(frame: .zero)
    public var hasSelectedButtonCallback: ((_ index: Int) -> ())?
    var labels = [UILabel]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(titles: [String], backgroundColors:[UIColor]) {
        self.labels = []
        let dataSource = ArrayDataSource<String>(data: titles)
        let viewSource = ClosureViewSource(viewUpdater: { (titleLabel: UILabel, data: String, index: Int) in
            titleLabel.tag = index
            if titles.count == backgroundColors.count {
                self.setup(label: titleLabel, title: data, backgroundColor: backgroundColors[index])
            } else {
                self.setup(label: titleLabel, title: data, backgroundColor: .JEWDefault())
            }
            self.labels.append(titleLabel)
        })
        
        let sizeSource = { (index: Int, data: String, collectionSize: CGSize) -> CGSize in
            return CGSize(width: 140, height: 50)
        }
        
        let provider = BasicProvider(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource,
            tapHandler: { context in
                if let hasSelectedButtonCallback = self.hasSelectedButtonCallback {
                    hasSelectedButtonCallback(context.index)
                }
        }
        )
        provider.layout = FlowLayout(spacing: 10, justifyContent: .center)
        collectionView.provider = provider
    }

    @objc func selectButton(sender: UIButton) {
        
    }
    
    func setup(label: UILabel, title: String, backgroundColor: UIColor, hasBorder: Bool = false) {
        label.isUserInteractionEnabled = true
        label.text = title
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = backgroundColor
        if hasBorder {
            label.layer.borderWidth = 2
        }
        label.layer.masksToBounds = false
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = 25
        label.clipsToBounds = true
    }
    
}

extension ChallengeButtonsView: JEWCodeView {
    public func buildViewHierarchy() {
        addSubview(collectionView)
        translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50)
            ])
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
    
    public func setupAdditionalConfiguration() {
        layoutIfNeeded()
    }
    
    
}
