//
//  LottieView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 01/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import SwiftUI
import Lottie

struct SUILottieView: UIViewRepresentable {
    
    let animationView = AnimationView()
    var animationFileName = "IconLottie"
    
    func makeUIView(context: UIViewRepresentableContext<SUILottieView>) -> UIView {
        let view = UIView()
        let loadAnimation = Animation.named(animationFileName, bundle: Bundle.main)
        animationView.animation = loadAnimation
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1.0
        animationView.play(fromFrame: AnimationFrameTime(89), toFrame: AnimationFrameTime(89), loopMode: .playOnce, completion: nil)
       
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }
    
    func startAnimation() {
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func stopAnimation() {
        animationView.play(fromFrame: AnimationFrameTime(89), toFrame: AnimationFrameTime(89), loopMode: .playOnce, completion: nil)
    }
    
   func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SUILottieView>) {
    
    }
    
}

