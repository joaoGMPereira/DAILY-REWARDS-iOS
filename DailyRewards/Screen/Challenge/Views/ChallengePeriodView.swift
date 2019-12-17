//
//  ChallengePeriodView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 13/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import UIKit
import JewFeatures

class ChallengePeriodView: UIView {
    var periodTitle = UILabel(frame: .zero)
    var periodView = JEWNPSView(frame: .zero)
    var periodArray: [Avaliation] = []
    
    //MARK: Constraints
    var heightViewConstraint = NSLayoutConstraint()
    var heightPeriodViewConstraint = NSLayoutConstraint()
    
    public var hasSelectedButtonCallback: ((_ totalIndex: Int, _ index: Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupPeriod()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPeriod() {
        periodArray.append(Avaliation.init(text: "Diario", width: 100))
        periodArray.append(Avaliation.init(text: "Semanal", width: 100))
        periodArray.append(Avaliation.init(text: "Mensal", width: 100))
        periodView.setIndividualSelection(individualSelection: true).setup(avaliations: periodArray)
        periodView.hasSelectedButtonCallback = { (selectedIndex) in
            if let hasSelectedButtonCallback = self.hasSelectedButtonCallback {
                hasSelectedButtonCallback(self.periodArray.count, selectedIndex)
            }
        }
    }
    
    public func selectType(index: Int) {
        periodView.unselectButtons(selectIndex: index)
    }
}

extension ChallengePeriodView: JEWCodeView {
    func buildViewHierarchy() {
        addSubview(periodTitle)
        addSubview(periodView)
        translatesAutoresizingMaskIntoConstraints = false
        periodTitle.translatesAutoresizingMaskIntoConstraints = false
        periodView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            periodTitle.topAnchor.constraint(equalTo: topAnchor),
            periodTitle.bottomAnchor.constraint(equalTo: periodView.topAnchor, constant: -8),
            periodTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            periodTitle.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        
        heightPeriodViewConstraint = periodView.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([
            heightPeriodViewConstraint,
            periodView.bottomAnchor.constraint(equalTo: bottomAnchor),
            periodView.leadingAnchor.constraint(equalTo: leadingAnchor),
            periodView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        
        heightViewConstraint = heightAnchor.constraint(equalToConstant: 60)
        NSLayoutConstraint.activate([
            heightViewConstraint
            ])
        
        recalculateperiodViewHeight()
    }
    
    func recalculateperiodViewHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.heightPeriodViewConstraint.constant = self.periodView.collectionView.contentSize.height
            self.heightViewConstraint.constant = self.heightPeriodViewConstraint.constant + 28
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
                self.periodView.selectedButton(index: 0)
            })
        }
    }
    
    func setupAdditionalConfiguration() {
        periodTitle.text = "Período:"
        periodTitle.textColor = UIColor.JEWDefault()
    }
    
    
}
