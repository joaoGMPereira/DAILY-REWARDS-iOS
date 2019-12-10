//
//  ChallengeViewController+UIScrollViewDelegate.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 25/11/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import UIKit
import JewFeatures

extension ChallengeViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    
    func animateExpandHeader() {
        if self.headerHeightConstraint.constant != 150 {
            headerView.setColorViewAlpha(alpha: 0.6)
            headerView.setBackgroundAlpha(alpha: 1)
            self.headerHeightConstraint.constant = 150
            UIView.animate(withDuration:ExpandableViewConstants.animationDuration, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func animateCollapseHeader() {
        if self.headerHeightConstraint.constant != 65 {
            headerView.setColorViewAlpha(alpha: 1)
            headerView.setBackgroundAlpha(alpha: 0)
            self.headerHeightConstraint.constant = 65
            UIView.animate(withDuration:ExpandableViewConstants.animationDuration, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < ExpandableViewConstants.zero {
            scrollViewMovingDown(scrollView: scrollView)
        } else if scrollView.contentOffset.y > ExpandableViewConstants.zero && self.headerHeightConstraint.constant >= ExpandableViewConstants.collapseMinimumHeightHeader {
                scrollViewMovingUp(scrollView: scrollView)
        }
    }
    
    func scrollViewMovingDown(scrollView: UIScrollView) {
        if self.headerHeightConstraint.constant != ExpandableViewConstants.maximumHeightHeader {
            self.headerHeightConstraint.constant = ExpandableViewConstants.maximumHeightHeader
            headerView.incrementColorAlpha(offset: self.headerHeightConstraint.constant)
            headerView.incrementBackgroundImageAlpha(offset: self.headerHeightConstraint.constant)
            self.headerView.changeConstants(shouldExpand: true)
        }
    }
    
    func scrollViewMovingUp(scrollView: UIScrollView) {
        if self.headerHeightConstraint.constant != ExpandableViewConstants.collapseMinimumHeightHeader {
            self.headerHeightConstraint.constant = ExpandableViewConstants.collapseMinimumHeightHeader
            headerView.decrementColorAlpha(offset: self.headerHeightConstraint.constant)
            headerView.decrementBackgroundImageAlpha(offset: self.headerHeightConstraint.constant)
            self.headerView.changeConstants(shouldExpand: false)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerHeightConstraint.constant > ExpandableViewConstants.maximumHeightHeader {
            animateExpandHeader()
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerHeightConstraint.constant > ExpandableViewConstants.maximumHeightHeader{
            animateExpandHeader()
        }
    }
}
