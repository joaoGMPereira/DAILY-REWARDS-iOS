//
//  AnimationView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 06/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import UIKit
typealias SelectedCellFinished = ((_ finished: Bool) -> Void)

class SelectedAnimationView: UIView {
    var parentView: UIView
    var superView: UIView
    var isExpanded: Bool = false
    
    init(frame: CGRect, superView: UIView, parentView: UIView) {
        self.parentView = parentView
        self.superView = superView
        super.init(frame: frame)
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(frame: CGRect, color: UIColor, animationFinished: @escaping SelectedCellFinished) {
        self.backgroundColor = color
        let cellFrameInSuperView = superView.convert(frame, to: parentView)
        self.frame = cellFrameInSuperView
        parentView.addSubview(self)
        self.alpha = 1
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.layer.transform = CATransform3DMakeScale(5, 5, 1.0)
            self.alpha = 0
        }) { (finished) in
            self.isExpanded = true
            self.removeFromSuperview()
            self.layer.transform = CATransform3DMakeScale(1, 1, 1.0)
            animationFinished(true)
        }
    }
    
    func hide(animationFinished: @escaping SelectedCellFinished) {
        parentView.addSubview(self)
        self.alpha = 0
        self.layer.transform = CATransform3DMakeScale(5, 5, 1.0)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.layer.transform = CATransform3DMakeScale(1, 1, 1.0)
            self.alpha = 1
        }) { (finished) in
            self.isExpanded = false
            self.removeFromSuperview()
            animationFinished(true)
        }
    }
}
