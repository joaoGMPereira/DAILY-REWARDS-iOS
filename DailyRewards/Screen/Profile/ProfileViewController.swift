//
//  ProfileViewController.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 27/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import UIKit
import JewFeatures
import PodAsset
import Hero
import FirebaseAuth

protocol ProfileViewControllerProtocol: class {
    func displayProfile(image: UIImage)
    func displayProfile(email: String)
    func displayProfile(name: String)
    func displaySignOut()
    func displayVote(index: Int)
    func displayBiometricOn()
    func displayBiometricOff()
}

class ProfileViewController: UIViewController {
    
    //MARK: UIProperties
    var profileImageView: UIImageView = UIImageView(frame: .zero)
    var contentProfileView: UIView = UIView(frame: .zero)
    var profileNameLabel: UILabel = UILabel(frame: .zero)
    var profileEmailLabel: UILabel = UILabel(frame: .zero)
    var signOutButton = UIButton(frame: .zero)
    var optionsView = ScrollableStackView(frame: .zero)
    var popupMessageView: JEWPopupMessage? = nil
    var npsTitleLabel = UILabel(frame: .zero)
    var npsView = JEWNPSView(frame: .zero)
    var optionViewsArray = [OptionView]()
    
    //MARK: Properties
    var interactor: ProfileInteractorProtocol?
    var router = DailyRewardsRouter()
    
    //MARK: Setup
    func setup() {
        let interactor = ProfileInteractor()
        self.interactor = interactor
        let presenter = ProfilePresenter()
        presenter.viewController = self
        interactor.presenter = presenter
    }
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = ProfileConstants.title.rawValue
        popupMessageView = JEWPopupMessage(parentViewController: self)
        profileImageView.setupRounded(borderColor: .white)
        setupSignOut()
        setupLeftButton()
        setupOptions()
        setupNPS()
    }
    
    func setupLeftButton() {
        let exitButton = UIButton(frame: .zero)
        exitButton.setTitle("X", for: .normal)
        exitButton.setTitleColor(.JEWDefault(), for: .normal)
        exitButton.imageView?.contentMode = .scaleAspectFit
        exitButton.addTarget(self, action: #selector(closeAction(_:)), for: .touchUpInside)
        
        let leftItem = UIBarButtonItem(customView: exitButton)
        let currWidth = leftItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = leftItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    func setupSignOut() {
        if let bundle = PodAsset.bundle(forPod: JEWConstants.Resources.podsJewFeature.rawValue) {
            signOutButton.setImage(UIImage(named: ImagesConstants.exitAppIconWhite.rawValue, in: bundle, compatibleWith: nil), for: .normal)
        }
        signOutButton.imageView?.contentMode = .scaleAspectFit
        signOutButton.tintColor = .JEWDefault()
        signOutButton.addTarget(self, action: #selector(signOut(_:)), for: .touchUpInside)
        
        let rightItem = UIBarButtonItem(customView: signOutButton)
        let currWidth = rightItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = rightItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func setupOptions() {
        let hasBiometricAuthenticationEnabled = JEWKeyChainWrapper.retrieveBool(withKey: JEWConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue)
        optionViewsArray = [OptionView]()
        let optionBiometricView = OptionView(frame: .zero)
        optionBiometricView.translatesAutoresizingMaskIntoConstraints = false
        optionBiometricView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        optionBiometricView.setupInfo(type: .biometric, isOn: hasBiometricAuthenticationEnabled ?? false)
        optionBiometricView.changeOptionCallback = {(type, isOn) in
            self.interactor?.biometric(isOn: isOn)
        }
        
        let optionNotificationView = OptionView(frame: .zero)
        optionNotificationView.translatesAutoresizingMaskIntoConstraints = false
        optionNotificationView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        optionNotificationView.setupInfo(type: .notification, isOn: false)
        optionNotificationView.changeOptionCallback = {(type, isOn) in
            
        }
        optionViewsArray.append(optionBiometricView)
        optionViewsArray.append(optionNotificationView)
        optionsView.setup(subViews: optionViewsArray, axis: .vertical)
        
    }
    
    func setupNPS() {
        npsView.setup(avaliationsCount: 10)
        npsView.hasSelectedButtonCallback = { (index) in
            self.interactor?.vote(index: index)
        }
        npsTitleLabel.text = ProfileConstants.npsTitle.rawValue
        npsTitleLabel.numberOfLines = 0
        npsTitleLabel.textColor = .JEWDefault()
        npsTitleLabel.font = .JEW13Bold()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func signOut(_ sender: Any) {
       interactor?.signOut()
    }
}

extension ProfileViewController: JEWCodeView {
    func buildViewHierarchy() {
        view.addSubview(contentProfileView)
        contentProfileView.addSubview(profileImageView)
        contentProfileView.addSubview(profileNameLabel)
        contentProfileView.addSubview(profileEmailLabel)
        contentProfileView.addSubview(signOutButton)
        view.addSubview(optionsView)
        view.addSubview(npsTitleLabel)
        view.addSubview(npsView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentProfileView.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        optionsView.translatesAutoresizingMaskIntoConstraints = false
        npsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        npsView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentProfileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentProfileView.heightAnchor.constraint(equalToConstant: 160),
            contentProfileView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentProfileView.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            profileImageView.centerYAnchor.constraint(equalTo: contentProfileView.safeAreaLayoutGuide.centerYAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            profileImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            profileNameLabel.leadingAnchor.constraint(equalTo: profileImageView.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            profileNameLabel.centerYAnchor.constraint(equalTo: profileImageView.safeAreaLayoutGuide.centerYAnchor, constant: 15),
            profileNameLabel.heightAnchor.constraint(equalToConstant: 30),
            profileNameLabel.trailingAnchor.constraint(equalTo: contentProfileView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            profileEmailLabel.leadingAnchor.constraint(equalTo: profileImageView.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            profileEmailLabel.centerYAnchor.constraint(equalTo: profileImageView.safeAreaLayoutGuide.centerYAnchor, constant: -15),
            profileEmailLabel.heightAnchor.constraint(equalToConstant: 30),
            profileEmailLabel.trailingAnchor.constraint(equalTo: contentProfileView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            optionsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            optionsView.topAnchor.constraint(equalTo: contentProfileView.safeAreaLayoutGuide.bottomAnchor),
            optionsView.heightAnchor.constraint(equalToConstant: 110),
            optionsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        
        NSLayoutConstraint.activate([
            npsTitleLabel.leadingAnchor.constraint(equalTo: npsView.leadingAnchor),
            npsTitleLabel.topAnchor.constraint(equalTo: optionsView.safeAreaLayoutGuide.bottomAnchor),
            npsTitleLabel.trailingAnchor.constraint(equalTo: npsView.trailingAnchor)
            ])
        
        NSLayoutConstraint.activate([
            npsView.topAnchor.constraint(greaterThanOrEqualTo: npsTitleLabel.safeAreaLayoutGuide.bottomAnchor, constant: 8),
            npsView.heightAnchor.constraint(equalToConstant: 100),
            npsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            npsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            ])
    }
    
    func setupAdditionalConfiguration() {
        view.layoutIfNeeded()
        background = UIColor.JEWBackground()
        contentProfileView.backgroundColor = UIColor.darkGray
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    
    func displayProfile(image: UIImage) {
        profileImageView.image = image
    }
    
    func displayProfile(name: String) {
        profileNameLabel.font = .JEW16Bold()
        profileNameLabel.textColor = .white
        profileNameLabel.text = name
    }
    
    func displayProfile(email: String) {
        profileEmailLabel.textColor = .white
        profileEmailLabel.text = email
    }
    
    func displaySignOut() {
        router.setupLoginViewController()
    }
    
    func displayVote(index: Int) {
        let voteViewController = INVSAlertViewController()
        voteViewController.setup(withHeight: 120, andWidth: 300, andCornerRadius: 8, andContentViewColor: .white)
        voteViewController.titleAlert = JEWConstants.Default.title.rawValue
        voteViewController.messageAlert = ProfileConstants.messageAlert.rawValue
        voteViewController.view.frame = view.bounds
        voteViewController.modalPresentationStyle = .overCurrentContext
        voteViewController.view.backgroundColor = .clear
        present(voteViewController, animated: true, completion: nil)
        voteViewController.confirmCallback = { (button) -> () in
            self.dismiss(animated: true) {
                self.popupMessageView?.show(withTextMessage: ProfileConstants.votedMessageAlert.rawValue)
            }
        }
        voteViewController.cancelCallback = { (button) -> () in
            self.npsView.unselectButtons()
        }
    }
    
    func displayBiometricOn() {
        biometricInfoPopup()
    }
    
    func displayBiometricOff() {
        JEWKeyChainWrapper.clear()
    }
    
    private func biometricInfoPopup() {
        let biometricViewController = INVSAlertViewController()
        biometricViewController.setup(withHeight: 200, andWidth: 300, andCornerRadius: 8, andContentViewColor: .white)
        biometricViewController.titleAlert = JEWConstants.Default.title.rawValue
        biometricViewController.messageAlert = JEWConstants.EnableBiometricViewController.biometricMessageType()
        biometricViewController.view.frame = view.bounds
        biometricViewController.modalPresentationStyle = .overCurrentContext
        biometricViewController.view.backgroundColor = .clear
        present(biometricViewController, animated: true, completion: nil)
        biometricViewController.confirmCallback = { (button) -> () in
            self.dismiss(animated: true) {
                JEWKeyChainWrapper.saveBool(withValue: true, andKey: JEWConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue)
            }
        }
        biometricViewController.cancelCallback = { (button) -> () in
            if let biometricOption = self.optionViewsArray.first {
                biometricOption.isOnSwitch.isOn = false
            }
        }
    }
}
