//
//  Expandable+UpdateConstraints.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 26/11/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import UIKit

extension ExpandableHeaderView {
    func changeConstants(shouldExpand: Bool) {
        
        if(!shouldExpand) {
            collapseTitleCenterX()
            collapseIconCenterXY()
            collapseIconHeight()
            collapseIconWidth()

        }
        if(shouldExpand) {
            expandTitleCenterX()
            expandImageCenterXY()
            expandImageHeight()
            expandImageHeight()
            expandImageWidth()
        }
        UIView.animate(withDuration: ExpandableHeaderViewConstants.animationDuration) {
            self.layoutIfNeeded()
            self.setRoundedCorners()
            
        }
    }
    
    //MARK - Collapse
    private func collapseTitleCenterX() {
        let distanceBetweenTitleAndView = titleLabel.frame.minX - frame.minX
        if titleLabel.frame.origin.x != ExpandableHeaderViewConstants.padding {
            let incrementValue = ExpandableHeaderViewConstants.padding - distanceBetweenTitleAndView
            updateConstraint(constraint: titleCenterXConstraint, fixedConstant: incrementValue)
        }
    }
    
    private func collapseIconCenterXY() {
        let distanceBetweenIconAndView = frame.maxX - iconImageView.frame.maxX + ExpandableHeaderViewConstants.minimumSizeImage/2
        if distanceBetweenIconAndView != ExpandableHeaderViewConstants.padding {
            let decrementValue = distanceBetweenIconAndView - ExpandableHeaderViewConstants.padding
            updateConstraint(constraint: imageCenterXConstraint, fixedConstant: decrementValue)
            collapseImageCenterY()
        }
    }
    
    private func collapseImageCenterY() {
        if let collapseHeaderCallback = collapseHeaderCallback, imageCenterYConstraint.constant != ExpandableHeaderViewConstants.zero {
            updateConstraint(constraint: imageCenterYConstraint, fixedConstant: ExpandableHeaderViewConstants.zero)
            collapseHeaderCallback()
        }
    }
    
    private func collapseIconHeight() {
        if imageHeightConstraint.constant > ExpandableHeaderViewConstants.minimumSizeImage {
            updateConstraint(constraint: imageHeightConstraint, fixedConstant: ExpandableHeaderViewConstants.minimumSizeImage)
        }
    }
    
    private func collapseIconWidth() {
        if imageWidthConstraint.constant > ExpandableHeaderViewConstants.minimumSizeImage {
            updateConstraint(constraint: imageWidthConstraint, fixedConstant: ExpandableHeaderViewConstants.minimumSizeImage)
        }
    }
    
    //MARK - Expand
    private func expandTitleCenterX() {
        let distanceBetweenTitleAndView = titleLabel.center.x - center.x
        if distanceBetweenTitleAndView < ExpandableHeaderViewConstants.zero {
            updateConstraint(constraint: titleCenterXConstraint, fixedConstant: ExpandableHeaderViewConstants.zero)
        }
    }
    
    private func expandImageCenterXY() {
        let distanceBetweenImageAndView = iconImageView.center.x - center.x
        if distanceBetweenImageAndView > ExpandableHeaderViewConstants.zero {
            updateConstraint(constraint: imageCenterXConstraint, fixedConstant: ExpandableHeaderViewConstants.zero)
            expandImageCenterY()
        }
    }
    
    private func expandImageCenterY() {
        if let expandHeaderCallback = expandHeaderCallback {
            updateConstraint(constraint: imageCenterYConstraint, fixedConstant: ExpandableHeaderViewConstants.padding)
            expandHeaderCallback()
        }
    }
    
    private func expandImageHeight() {
        if imageHeightConstraint.constant < ExpandableHeaderViewConstants.maximumSizeImage {
            updateConstraint(constraint: imageHeightConstraint, fixedConstant: ExpandableHeaderViewConstants.maximumSizeImage)
        }
    }
    
    private func expandImageWidth() {
        if imageWidthConstraint.constant < ExpandableHeaderViewConstants.maximumSizeImage {
            updateConstraint(constraint: imageWidthConstraint, fixedConstant: ExpandableHeaderViewConstants.maximumSizeImage)
        }
    }
    
    private func updateIncrementConstraint(constraint: NSLayoutConstraint, constant: CGFloat) {
        constraint.constant += constant
    }
    
    private func updateDecrementConstraint(constraint: NSLayoutConstraint, constant: CGFloat) {
        constraint.constant -= constant
    }
    
    private func updateConstraint(constraint: NSLayoutConstraint, fixedConstant: CGFloat) {
        constraint.constant = fixedConstant
    }
}
