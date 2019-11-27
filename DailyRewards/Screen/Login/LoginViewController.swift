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
import SwiftyRSA

protocol LoginViewControllerProtocol: class {
    func displayLogin(user: JEWUserModel)
    func displayLogin(error: String)
}

class LoginViewController: UIViewController {
    
    //MARK: UIProperties
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var iconLottieView: AnimationView!
    var popupMessageView: JEWPopupMessage? = nil
    
    //MARK: Properties
    var interactor: LoginInteractorProtocol?
    let router: DailyRewardsRouterProtocol = DailyRewardsRouter()
    //MARK: Setup
    func setup() {
        let interactor = LoginInteractor()
        self.interactor = interactor
        let presenter = LoginPresenter()
        presenter.viewController = self
        interactor.presenter = presenter
        interactor.setupSignIn()
    }
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupLottieIcon()
        self.setupGoogle()
        
        
    }
    
    func setupLottieIcon() {
        let loadAnimation = Animation.named("IconLottie", bundle: Bundle(for: type(of: self)))
        iconLottieView.animation = loadAnimation
        iconLottieView.contentMode = .scaleAspectFit
        iconLottieView.animationSpeed = 1.0
        iconLottieView.play(fromFrame: AnimationFrameTime(89), toFrame: AnimationFrameTime(89), loopMode: .playOnce, completion: nil)
    }
    
    func setupGoogle() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        signInButton.colorScheme = .dark
        signInButton.style = .wide
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Login"
        popupMessageView = JEWPopupMessage(parentViewController: self)
    }
    
//    func teste() {
//        do {
//        let publicKey = try PublicKey(pemEncoded: self.publickey())
//        let privateKey = try PrivateKey(pemEncoded: self.privateKey())
//            let str = "Clear Text"
//            let clear = try ClearMessage(string: str, using: .utf8)
//            let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
//
//            let data = encrypted.data
//            let base64String = encrypted.base64String
//
//
//            let encryptedDe = try EncryptedMessage(base64Encoded: "G/bQCVRjzHMZh1JdYQ+uDE+K0dgATRUk/OJs6Xdh6WM2Ibs6wa0NjNvwDYOriJgO0nEdpHFxuEn746uLdDi3lO3Fr6lJIw33Zq3j3LyhZNiz7uDoDKmlzmj81Um8qK5kuSK6+sHt1UvXQ7bCcsOi0oFZOoJMuVapUpIDBbSTNrM=")
//            let clearDe = try encryptedDe.decrypted(with: privateKey, padding: .PKCS1)
//
//            let dataDe = clearDe.data
//            let base64StringDe = clearDe.base64String
//            let string = try clearDe.string(encoding: .utf8)
//            print(string)
//
//        } catch let error {
//            print(error)
//        }
//    }
//    func publickey() -> String {
//        return "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCH125mKMggYUm9obIozUAUuBQdcv3Cntqn7fdfyNFWmaGx+64caQ371GgYx7VJthg7S9QyZBvuT95p/ZoH3qNfmAzks2qGpal93COwf4Y5TkWD0Vqcr/AtynlAupr3YA41CRiPdZT29kgGDcfdUPkAusC4CrR4oQ2kEkdO2aPQlwIDAQAB\n-----END PUBLIC KEY-----"
//    }
//    func privateKey() -> String {
//        return "-----BEGIN RSA PRIVATE KEY-----\nMIICXAIBAAKBgQCBiAGhrvvZ/CRzYJOXD+3qNGjtswuAVH/mpC8WcrKPzPDuTvQnFSSh3T3wjycdYMEqugiSS0KeZMJnHllyl2Hvz8tCS1N3vHOLLdXGIhhgqZrL/MYLxTRV7hdo4Uq9uUKSd0StXQmY6/nB2wgGiaGNXu0bLhomq3DpMgRrstW7iwIDAQABAoGABOnZ1f5DQ3OTFmVVc+eAyN+QE2Q1TXrnFyKnPpy/NUE66m9IR6s/pnwz+0oS28Rtz2cbKCF+t29vCGZYUkZ3yojWXQ3ZULRIl5gf3jVUXwbAN4PPiFIKAQEALbyOjjkUyg0Lg+TUeThlJzsC02uw7EFrD/iet6c24PO/8bVN5mECQQDkJxAI3frGddcwEepEHZQPKbD4rARtRG0ts4LyoPbmHOnT5MoPGpTKdrPBFKb7UG4IvRWKMehBIvkq4637JHaJAkEAkVdjDHYMjTu1JzeSAzKTcEyf2mQoi83RyYlORl6F/KU7tLglLIgIx0QSaNMzOQROq7p8TVX9IpPx0RNo8TGccwJBANomn6Za2hY5RvCnsKBAx/lXm+eqUvFHpD02j9b/IhUVQF9jO/EFMZAFwAq2fJOAbDXe1mG1JqZhkm34Fbs1OkECQAUPj+ldKu64B4TIEJN/7VZZtK88EZVco1NrLoiQvgWgE0Ylq1WznuqhWirAP+ZaWgrswWtH9TqBAEiRbnQHkDUCQFRCL0Mpv8L8x+Il8oI/W2IJeyEcYj1A9Bluu5fIsTAvjPhxJBL0DGIaanqMFURBrWc4HfACrzqFSGkuPoQaVKo=\n-----END RSA PRIVATE KEY-----"
//    }
}

extension LoginViewController: LoginViewControllerProtocol {
    func displayLogin(user: JEWUserModel) {
        if let popupMessage = popupMessageView {
            popupMessage.show(withTextMessage: "Sucesso", title: "\(JEWConstants.Default.title.rawValue)\n", popupType: .alert)
            router.setupChallengeViewController()
            
        }
    }
    
    func displayLogin(error: String) {
        if let popupMessage = popupMessageView {
            popupMessage.show(withTextMessage: error, title: "\(JEWConstants.Default.title.rawValue)\n", popupType: .error)
        }
    }
    
    
}

extension LoginViewController: JEWFloatingTextFieldDelegate {
    
    public func infoButtonAction(_ textField: JEWFloatingTextField) {
        let teste = JEWPopupMessage.init(parentViewController: self)
        teste.show(withTextMessage: "testando\n", title: "O teste", popupType: .custom(messageColor: .yellow, backgroundColor: .JEWLightGray()), shouldHideAutomatically: false)
    }
    
    public func toolbarAction(_ textField: JEWFloatingTextField, typeOfAction type: JEWKeyboardToolbarButton) {
        view.endEditing(true)
    }
    
    public func textFieldDidBeginEditing(_ textField: JEWFloatingTextField) {
        
    }
}

