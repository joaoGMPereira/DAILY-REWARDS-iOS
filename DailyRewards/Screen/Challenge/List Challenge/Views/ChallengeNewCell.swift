//
//  ChallengeView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 02/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import JewFeatures

class ChallengeNewCell: ScalingCarouselCell {
    
    let plusButton = UIButton(frame: .zero)
    var centerXButtonConstraint = NSLayoutConstraint()
    var heightButtonConstraint = NSLayoutConstraint()
    var widthButtonConstraint = NSLayoutConstraint()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMainViewContraints()
        setupPlusButtonConstraints()
        plusButton.isUserInteractionEnabled = false
        plusButton.setAttributedTitle(NSAttributedString(string: "+",
                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor.JEWDefault(), NSAttributedString.Key.font : UIFont.JEW24Bold()]), for: .normal)
    }
    
    func setupMainViewContraints() {
        mainView = UIView(frame: contentView.bounds)
        contentView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
    
    func setupPlusButtonConstraints() {
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(plusButton)
        let distance =  contentView.frame.minX - contentView.center.x
        centerXButtonConstraint = plusButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: distance)
        heightButtonConstraint = plusButton.heightAnchor.constraint(equalToConstant: 40)
        widthButtonConstraint = plusButton.widthAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([
            centerXButtonConstraint,
            plusButton.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            heightButtonConstraint,
            widthButtonConstraint
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
