//
//  GoogleButtonSignInView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 01/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import SwiftUI
import GoogleSignIn

struct SUIGoogleButtonSignInView: UIViewRepresentable {
    let signInButton = GIDSignInButton()
    func makeUIView(context: UIViewRepresentableContext<SUIGoogleButtonSignInView>) -> UIView {
        let view = UIView()
        signInButton.colorScheme = .dark
        signInButton.style = .wide
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor),
            signInButton.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
     }
     
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SUIGoogleButtonSignInView>) {
     
     }
}
