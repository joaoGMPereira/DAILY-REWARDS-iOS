//
//  ProfileHeaderView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 25/11/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import UIKit
import JewFeatures

public class ExpandableHeaderViewConstants {
    static let maximumHeightHeader:CGFloat = 150
    static let minimumHeightHeader:CGFloat = 100
    static let collapseMaximumHeightHeader:CGFloat = 85
    static let collapseMinimumHeightHeader:CGFloat = 65
    static let padding:CGFloat = 16
    static let minimumSizeImage:CGFloat = 40
    static let maximumSizeImage:CGFloat = 80
    static let minimumCenterX:CGFloat = 30
    static let zero: CGFloat = 0
    static let animationDuration = 0.5
    static let CenterXConstantOffset: CGFloat = 20
    static let SizeConstantOffSet: CGFloat = 4
}

public class ExpandableHeaderView: UIView {
    private var backgroundImageView = UIImageView()
    private var colorView = UIView()
    public var titleLabel = UILabel()
    public var iconImageView = UIImageView()
    
    var imageCenterYConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var imageCenterXConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var imageHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var imageWidthConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var titleCenterXConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    var imageCallback: ((_ imageView: UIImageView) -> ())?
    
    var expandHeaderCallback: (() -> ())?
    
    var collapseHeaderCallback: (() -> ())?
    
    init(frame:CGRect, title: String = "", titleFont: UIFont = .systemFont(ofSize: 16), color: UIColor = .black, textColor: UIColor = .black, iconImage: UIImage? = nil, backgroundImage: UIImage? = nil) {
        self.titleLabel.font = titleFont
        self.titleLabel.text = title.capitalized
        self.titleLabel.textColor = textColor
        self.colorView.backgroundColor = color
        self.iconImageView.image = iconImage
        self.backgroundImageView.image = backgroundImage
        super.init(frame: frame)
        self.backgroundColor = color
        setUpView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundImageView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(colorView)
        let constraints:[NSLayoutConstraint] = [
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            colorView.topAnchor.constraint(equalTo: self.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        backgroundImageView.contentMode = .scaleAspectFill
        colorView.alpha = 0.6
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        titleCenterXConstraint = titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let titlesConstraints:[NSLayoutConstraint] = [
            titleCenterXConstraint,
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleLabel.heightAnchor.constraint(equalToConstant: 35)
            ]
        NSLayoutConstraint.activate(titlesConstraints)
        titleLabel.textAlignment = .center
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconImageView)
        
        
        imageCenterXConstraint = iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        imageCenterYConstraint = iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: ExpandableHeaderViewConstants.padding)
        
        
        imageHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: ExpandableHeaderViewConstants.maximumSizeImage)
        imageWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: ExpandableHeaderViewConstants.maximumSizeImage)
        let imageConstraints:[NSLayoutConstraint] = [
            imageCenterXConstraint,
            imageCenterYConstraint,
            imageHeightConstraint,
            imageWidthConstraint
        ]
        NSLayoutConstraint.activate(imageConstraints)
        layoutIfNeeded()
        setRoundedCorners()
        iconImageView.isUserInteractionEnabled = true
        let tapImage = UITapGestureRecognizer.init(target: self, action: #selector(imageAction(_:)))
        iconImageView.addGestureRecognizer(tapImage)
    }
    
    func setRoundedCorners() {
        iconImageView.layer.borderWidth = 2
        iconImageView.layer.masksToBounds = false
        iconImageView.layer.borderColor = UIColor.white.cgColor
        iconImageView.layer.cornerRadius = iconImageView.frame.width/2
        iconImageView.clipsToBounds = true
    }
    
    @objc func imageAction(_ sender: UIImageView) {
        if let imageCallback = imageCallback {
            imageCallback(sender)
        }
    }
    
    func decrementColorAlpha(offset: CGFloat) {
        if self.colorView.alpha <= 1 {
            let alphaOffset = (offset/500)/85
            self.colorView.alpha += alphaOffset
        }
    }
    
    func decrementBackgroundImageAlpha(offset: CGFloat) {
        if self.backgroundImageView.alpha >= ExpandableHeaderViewConstants.zero {
            let alphaOffset = max((offset - 65)/85.0, 0)
            self.backgroundImageView.alpha = alphaOffset
        }
    }
    
    func incrementBackgroundImageAlpha(offset: CGFloat) {
        if self.backgroundImageView.alpha <= 1 {
            let alphaOffset = max((offset - 65)/85, 0)
            self.backgroundImageView.alpha = alphaOffset
        }
    }
    
    func setBackgroundAlpha(alpha: CGFloat) {
        UIView.animate(withDuration: ExpandableHeaderViewConstants.animationDuration) {
            self.backgroundImageView.alpha = alpha
        }
    }
    
    func setColorViewAlpha(alpha: CGFloat) {
        UIView.animate(withDuration: ExpandableHeaderViewConstants.animationDuration) {
            self.colorView.alpha = alpha
        }
    }
    
    func incrementColorAlpha(offset: CGFloat) {
        if self.colorView.alpha >= 0.6 {
            let alphaOffset = (offset/200)/85
            self.colorView.alpha -= alphaOffset
        }
    }
}
