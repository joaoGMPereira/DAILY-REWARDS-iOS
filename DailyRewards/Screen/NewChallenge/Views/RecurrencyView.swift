//
//  RecurrencyView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 11/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import UIKit
import JewFeatures

class RecurrencyView: UIView {
    var recurrencyTitle = UILabel(frame: .zero)
    var recurrencyView = JEWNPSView(frame: .zero)
    var recurrencyArray: [Avaliation] = []
    
    //MARK: Constraints
    var heightViewConstraint = NSLayoutConstraint()
    var heightRecurrencyViewConstraint = NSLayoutConstraint()
    
    public var hasSelectedButtonCallback: ((_ totalIndex: Int, _ index: Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupRecurrency()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRecurrency() {
        recurrencyArray.append(Avaliation.init(text: "S"))
        recurrencyArray.append(Avaliation.init(text: "T"))
        recurrencyArray.append(Avaliation.init(text: "Q"))
        recurrencyArray.append(Avaliation.init(text: "Q"))
        recurrencyArray.append(Avaliation.init(text: "S"))
        recurrencyArray.append(Avaliation.init(text: "S"))
        recurrencyArray.append(Avaliation.init(text: "D"))
        recurrencyArray.append(Avaliation.init(text: "Todos", width: 70))
        recurrencyView.setIndividualSelection(individualSelection: true).setup(avaliations: recurrencyArray)
        recurrencyView.hasSelectedButtonCallback = { (selectedIndex) in
            if let hasSelectedButtonCallback = self.hasSelectedButtonCallback {
                hasSelectedButtonCallback(self.recurrencyArray.count, selectedIndex)
            }
            
        }
    }
    
    public func unselectButtons(notUnselectIndex: Int) {
        recurrencyView.unselectButtons(notUnselectIndex: notUnselectIndex)
    }
    
    public func unselectButton(indexButton: Int) {
        recurrencyView.unselectButton(indexButton: indexButton)
    }
}

extension RecurrencyView: JEWCodeView {
    func buildViewHierarchy() {
        addSubview(recurrencyTitle)
        addSubview(recurrencyView)
        translatesAutoresizingMaskIntoConstraints = false
        recurrencyTitle.translatesAutoresizingMaskIntoConstraints = false
        recurrencyView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            recurrencyTitle.topAnchor.constraint(equalTo: topAnchor),
            recurrencyTitle.bottomAnchor.constraint(equalTo: recurrencyView.topAnchor, constant: -8),
            recurrencyTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            recurrencyTitle.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        heightRecurrencyViewConstraint = recurrencyView.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([
            heightRecurrencyViewConstraint,
            recurrencyView.bottomAnchor.constraint(equalTo: bottomAnchor),
            recurrencyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recurrencyView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        heightViewConstraint = heightAnchor.constraint(equalToConstant: 60)
        NSLayoutConstraint.activate([
            heightViewConstraint
        ])
        
        recalculateRecurrencyViewHeight()
    }
    
    func recalculateRecurrencyViewHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.heightRecurrencyViewConstraint.constant = self.recurrencyView.collectionView.contentSize.height
            self.heightViewConstraint.constant = self.heightRecurrencyViewConstraint.constant + 28
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
            })
        }
    }
    
    func setupAdditionalConfiguration() {
        recurrencyTitle.text = "Frequência:"
        recurrencyTitle.textColor = UIColor.JEWDefault()
    }
    
    
}
