//
//  MyChallengesCollectionViewDataSourxce.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 03/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import UIKit
import JewFeatures

class MyChallengesCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    var challenges: [Challenge] = []
    var scrollableStackView: ScrollableStackView
    var animationView: SelectedAnimationView?
    var scalingCollectionView: ScalingCarouselView
    var viewControllerDelegate: ChallengeViewControllerDelegate?
    
    init (challenges: [Challenge], scrollableStackView: ScrollableStackView, collectionView: ScalingCarouselView, viewControllerDelegate: ChallengeViewControllerDelegate?, animationView: SelectedAnimationView?) {
        self.challenges = challenges
        self.scrollableStackView = scrollableStackView
        self.scalingCollectionView = collectionView
        self.viewControllerDelegate = viewControllerDelegate
        self.animationView = animationView
        super.init()
        self.scalingCollectionView.dataSource = self
        self.scalingCollectionView.delegate = self
    }
    
    func newChallengeCellPosition() -> Int {
        return challenges.count - 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challenges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = ChallengeCellFactory.cellIdentifier(cellType: challenges[indexPath.row].cellType)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        if let challengeNewCell = cell as? ChallengeNewCell {
            challengeNewCell.mainView.backgroundColor = .clear
        }
        
        if let challengeInfoCell = cell as? ChallengeInfoCell {
            challengeInfoCell.mainView.backgroundColor = UIColor.JEWLightBlack()
            challengeInfoCell.setupInfo(challenge: challenges[indexPath.row])
        }
        
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell(collectionView, didSelectItemAt: indexPath) { (finished) in
            if finished {
                let challenge = self.challenges[indexPath.row]
                self.viewControllerDelegate?.selectedCell(cellType: challenge.cellType, challenge: challenge)
            }
        }
        collectionView.scrollToItem(at: scalingCollectionView.lastCurrentCenterCellIndex ?? IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func selectedCell(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, selectionFinished: @escaping SelectedCellFinished) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ScalingCarouselCell, let cellLayout = collectionView.layoutAttributesForItem(at: indexPath) {
            selectAnimation(cell: cell)
            if let animationView = animationView {
                var color = cell.mainView.backgroundColor
                color = color?.withAlphaComponent(0.3)
                animationView.show(frame: cellLayout.frame, color: color ?? .clear) { (finished) in
                    selectionFinished(finished)
                }
            }
        }
    }
    
    func selectAnimation(cell: ScalingCarouselCell) {
        cell.layer.animate(width: 1.02, height: 1.02)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        collectionViewScrollPosition()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewScrollPosition()
    }
    
    func collectionViewScrollPosition() {
        let centerPoint = self.scrollableStackView.convert(scalingCollectionView.center, to: scalingCollectionView)
        let indexCentered = scalingCollectionView.indexPathForItem(at: centerPoint)
        
        if let indexPathCentered = indexCentered {
            isShowingInCenterNewCell(indexPathCentered: indexPathCentered)
            isShowingNewCell(indexPathCentered: indexPathCentered)
            isShowingInCenterChallengeCell(indexPathCentered: indexPathCentered)
            isShowingNotCenterChallengeCell(indexPathCentered: indexPathCentered)
        }
    }
    
    func isShowingInCenterChallengeCell(indexPathCentered: IndexPath) {
        if let collectionViewCell = scalingCollectionView.cellForItem(at: indexPathCentered) as? ChallengeInfoCell {
            collectionViewCell.edged()
        }
    }
    
    func isShowingNotCenterChallengeCell(indexPathCentered: IndexPath) {
        let showingNotCenterIndexPaths = scalingCollectionView.indexPathsForVisibleItems.filter({$0 != indexPathCentered})
        for indexPath in showingNotCenterIndexPaths {
            if let collectionViewCell = scalingCollectionView.cellForItem(at: indexPath) as? ChallengeInfoCell {
                collectionViewCell.centered()
            }
        }
        
    }
    
    func isShowingInCenterNewCell(indexPathCentered: IndexPath) {
        let showingNewCell = scalingCollectionView.indexPathsForVisibleItems.contains(IndexPath(row: newChallengeCellPosition(), section: 0))
        if showingNewCell && indexPathCentered.row != newChallengeCellPosition(), let collectionViewCell = scalingCollectionView.cellForItem(at: IndexPath(row: newChallengeCellPosition(), section: 0)) as? ChallengeNewCell {
            collectionViewCell.mainView.animateBackgroundLayerColor(toColor: .clear, duration: 0.3)
            collectionViewCell.plusButton.setAttributedTitle(NSAttributedString(string: "+", attributes: [NSAttributedString.Key.foregroundColor : UIColor.JEWDefault(), NSAttributedString.Key.font : UIFont.JEW24Bold()]), for: .normal)
            
            let distance =  collectionViewCell.contentView.frame.minX - collectionViewCell.contentView.center.x
            collectionViewCell.centerXButtonConstraint.constant = distance
            collectionViewCell.heightButtonConstraint.constant = 40
            collectionViewCell.widthButtonConstraint.constant = 40
            UIView.animate(withDuration: 0.3) {
                collectionViewCell.layoutIfNeeded()
            }
        }
    }
    
    func isShowingNewCell(indexPathCentered: IndexPath) {
        if let collectionViewCell = scalingCollectionView.cellForItem(at: indexPathCentered) as? ChallengeNewCell {
            if indexPathCentered.row == newChallengeCellPosition() {
                collectionViewCell.mainView.animateBackgroundLayerColor(toColor: UIColor.JEWLightBlack(), duration: 0.3)
                collectionViewCell.plusButton.setAttributedTitle(NSAttributedString(string: "+",attributes: [NSAttributedString.Key.foregroundColor : UIColor.JEWDefault(), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 60)]), for: .normal)
                collectionViewCell.centerXButtonConstraint.constant = 0
                collectionViewCell.heightButtonConstraint.constant = 60
                collectionViewCell.widthButtonConstraint.constant = 60
                UIView.animate(withDuration: 0.3) {
                    collectionViewCell.layoutIfNeeded()
                }
            }
        }
    }
}
