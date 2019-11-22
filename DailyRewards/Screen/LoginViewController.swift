//
//  LoginViewController.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 14/11/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Lottie
import JewFeatures

class LoginViewController: UIViewController {

    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var iconLottieView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        //GIDSignIn.sharedInstance().signIn()
        signInButton.colorScheme = .dark
        signInButton.style = .wide
        
        let loadAnimation = Animation.named("IconLottie", bundle: Bundle(for: type(of: self)))
        iconLottieView.animation = loadAnimation
        iconLottieView.contentMode = .scaleAspectFit
        iconLottieView.animationSpeed = 1.0
        iconLottieView.play(fromFrame: AnimationFrameTime(89), toFrame: AnimationFrameTime(89), loopMode: .playOnce, completion: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let teste = JEWPresentBaseViewController()
        self.present(teste, animated: true) {
            teste.showLoading()
        }
//        let errorViewController = JEWConnectorHelpers.setupAlertController(lastViewController: self, message: "OLA Teste", title: "Title Test")
//        errorViewController.confirmCallback = { (button) -> () in
//            Timer.init(timeInterval: 3.0, repeats: false, block: { (timer) in
//                errorViewController.dismiss(animated: true) {
//                }
//            })
//
//        }
//        let teste = JEWPopupMessage.init(parentViewController: self)
//        teste.show(withTextMessage: "Teste")
//        teste.show(withAttributedMessage: "testando", title: "O teste", popupType: .alert, shouldHideAutomatically: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

}
