//
//  ChallengeImageView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 10/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import UIKit
import JewFeatures

class ChallengeImageView: UIView {
    var challengeImageButton = UIButton(frame: .zero)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChallengeImage()
        setupView()
    }
    
    func setupChallengeImage() {
        challengeImageButton.setImage(UIImage(named: "edit"), for: .normal)
        challengeImageButton.tintColor = .JEWBlack()
        challengeImageButton.backgroundColor = .JEWDefault()
        challengeImageButton.addTarget(self, action: #selector(changeImage(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changeImage(_ sender: Any) {
        self.challengeImageButton.layer.animate()
    }
}

extension ChallengeImageView: JEWCodeView {
    func buildViewHierarchy() {
        addSubview(challengeImageButton)
        translatesAutoresizingMaskIntoConstraints = false
        challengeImageButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            challengeImageButton.widthAnchor.constraint(equalToConstant: 150),
            challengeImageButton.heightAnchor.constraint(equalToConstant: 150),
            challengeImageButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            challengeImageButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 160)
        ])
        layoutIfNeeded()
        challengeImageButton.setupRounded(borderColor: .white)
    }
    
    func setupAdditionalConfiguration() {
        
    }
}
