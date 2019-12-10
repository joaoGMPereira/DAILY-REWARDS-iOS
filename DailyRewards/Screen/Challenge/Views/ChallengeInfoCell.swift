//
//  ChallengeCell.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 02/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import JewFeatures

class ChallengeInfoCell: ScalingCarouselCell {
    
    //MARK: Constants
    let minimumSize: CGFloat = 45
    let maximumSize: CGFloat = 60
    let cornerRadius: CGFloat = 10
    let padding16: CGFloat = 16
    let padding8: CGFloat = 8
    let paddingMinus8: CGFloat = -8
    
    //MARK: UIProperties
    let iconImageView = UIImageView(frame: .zero)
    let titleLabel = UILabel(frame: .zero)
    let descriptionLabel = UILabel(frame: .zero)
    let statusLabel = UILabel(frame: .zero)
    
    //MARK: Constraints
    var centerXIconConstraint = NSLayoutConstraint()
    var centerYIconConstraint = NSLayoutConstraint()
    var heightIconConstraint = NSLayoutConstraint()
    var widthIconConstraint = NSLayoutConstraint()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInfo(challenge: Challenge) {
        titleLabel.text = challenge.title
        titleLabel.textColor = .JEWDefault()
        titleLabel.font = .JEW20Bold()
        titleLabel.numberOfLines = 2
        
        descriptionLabel.text = challenge.description
        descriptionLabel.textColor = .white
        descriptionLabel.font = .JEW16()
        descriptionLabel.numberOfLines = 3
        
        statusLabel.text = challenge.challengeStatus.message()
        statusLabel.textColor = challenge.challengeStatus.color()
        statusLabel.font = .JEW16()
        statusLabel.numberOfLines = 1
        
        hero.isEnabled = true
        iconImageView.hero.id = "\(HeroConstants.challengeImageHero.rawValue)\(challenge.title)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.setupRounded(borderColor: .white, cornerRadius: cornerRadius)
        iconImageView.layer.backgroundColor = UIColor.JEWDefault().cgColor
    }
}

extension ChallengeInfoCell: JEWCodeView {
    func buildViewHierarchy() {
        mainView = UIView(frame: contentView.bounds)
        contentView.addSubview(mainView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(descriptionLabel)
        mainView.addSubview(statusLabel)
        mainView.addSubview(iconImageView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: padding16),
            titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: padding8),
            titleLabel.heightAnchor.constraint(equalToConstant: maximumSize),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: iconImageView.leadingAnchor, constant: paddingMinus8)
            ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: padding16),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: maximumSize),
            descriptionLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: paddingMinus8)
            ])
        
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: padding16),
            statusLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: paddingMinus8),
            statusLabel.heightAnchor.constraint(equalToConstant: minimumSize),
            statusLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: paddingMinus8)
            ])
        
        let distance = contentView.frame.minX - contentView.center.x + minimumSize/1.4
        let distanceY = contentView.center.y - contentView.frame.maxY + minimumSize/1.4
        centerXIconConstraint = iconImageView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: distance)
        centerYIconConstraint = iconImageView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor, constant: distanceY)
        heightIconConstraint = iconImageView.heightAnchor.constraint(equalToConstant: minimumSize)
        widthIconConstraint = iconImageView.widthAnchor.constraint(equalToConstant: minimumSize)
        
        NSLayoutConstraint.activate([
            centerXIconConstraint,
            centerYIconConstraint,
            heightIconConstraint,
            widthIconConstraint
            ])
    }
    
    func setupAdditionalConfiguration() {}
    //grande
    func edged() {
        let distanceX = contentView.frame.maxX - contentView.center.x - maximumSize/1.6
        let distanceY = contentView.center.y - contentView.frame.maxY + maximumSize/1.6
        centerYIconConstraint.constant = distanceY
        centerXIconConstraint.constant = distanceX
        heightIconConstraint.constant = maximumSize
        widthIconConstraint.constant = maximumSize
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            self.iconImageView.setupRounded(borderColor: .white, cornerRadius: self.cornerRadius)
        }
    }
    //pequeno
    func centered() {
        let distanceX = contentView.frame.maxX - contentView.center.x - minimumSize/1.4
        let distanceY = contentView.center.y - contentView.frame.maxY + minimumSize/1.4
        centerXIconConstraint.constant = distanceX
        centerYIconConstraint.constant = distanceY
        heightIconConstraint.constant = minimumSize
        widthIconConstraint.constant = minimumSize
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            self.iconImageView.setupRounded(borderColor: .white, cornerRadius: self.cornerRadius)
        }
    }
    
}
