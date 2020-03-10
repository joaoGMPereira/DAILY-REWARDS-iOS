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
        //presenter.viewController = self
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
    
    
}

extension LoginViewController: LoginViewControllerProtocol {
    func displayLogin(user: JEWUserModel) {
        askForBiometric()
    }
    
    func askForBiometric() {
        JEWBiometricsChallenge.checkLoggedUser(keychainKey: JEWConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue, successChallenge: {
            DailyRewardsRouter.setupChallengeViewController()
        }) { (type) in
            switch type {
            case .default:
                //let message = JEWBiometrics.faceIDAvailable() ? BioMetricsFaceIDErrors.kDefaultFaceIDErrorAuthentication.rawValue : BioMetricsTouchIDErrors.kDefaultTouchIDErrorAuthentication.rawValue
                //self.popupMessageView?.show(withTextMessage: message, title: "\(JEWConstants.Default.title.rawValue)\n", popupType: .error, shouldHideAutomatically: true)
                DailyRewardsRouter.setupChallengeViewController()
            case .error(let error):
                self.popupMessageView?.show(withTextMessage: error.message(), title: "\(error.title())\n", popupType: .error, shouldHideAutomatically: true)
            case .goSettings(let error):
                self.popupMessageView?.show(withTextMessage: error.message(), title: "\(error.title())\n", popupType: .error, shouldHideAutomatically: true)
            }
        }
    }
    
    func displayLogin(error: String) {
        if let popupMessage = popupMessageView {
            popupMessage.show(withTextMessage: error, title: "\(JEWConstants.Default.title.rawValue)\n", popupType: .error)
        }
    }
}

