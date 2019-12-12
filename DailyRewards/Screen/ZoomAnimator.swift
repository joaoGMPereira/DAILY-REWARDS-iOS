//
//  ZoomAnimator.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 10/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import JewFeatures
import CollectionKit

open class ZoomAnimator: Animator {
    open override func update(collectionView: CollectionView, view: UIView, at: Int, frame: CGRect) {
        super.update(collectionView: collectionView, view: view, at: at, frame: frame)
        let bounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        let absolutePosition = CGPoint(x: frame.midX, y: frame.midY) - collectionView.contentOffset
        let scale = 1 - max(0, absolutePosition.distanceTo(CGPoint(x: bounds.midX, y: bounds.midY)) - 150) / (max(bounds.width, bounds.height) - 150)
        view.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
    }
}
