//
//  NewChallengeViewController.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 03/12/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import UIKit
import JewFeatures
import Lottie
import PodAsset

protocol NewChallengeViewControllerProtocol: class {
    
}

class NewChallengeViewController: UIViewController {
    
    //MARK: UIProperties
    var scrollableStackView = ScrollableStackView(frame: .zero)
    var challengeNameImageView = UIView.init(frame: .zero)
    var challengeImageButton = UIButton(frame: .zero)
    var challengeNameTextField = JEWFloatingTextField(frame: .zero)
    var recurrencyTitle = UILabel(frame: .zero)
    var recurrencyView = JEWNPSView(frame: .zero)
    
    var goalReachTitle = UILabel(frame: .zero)
    var goalReachStackView = ScrollableStackView(frame: .zero)
    var goalReachSwitch = UISwitch(frame: .zero)
    let goalReachAnimation = AnimationView(frame: .zero)
    var goalReachTextField = JEWFloatingTextField(frame: .zero)
    
    //MARK: Constraints
    var heightRecurrencyViewConstraint = NSLayoutConstraint()
    
    //MARK: Properties
    var keyboardSize: CGRect = .zero
    var interactor: NewChallengeInteractorProtocol?
    var recurrencyArray: [Avaliation] = []
    
    //MARK: Setup
    func setup() {
        let interactor = NewChallengeInteractor()
        self.interactor = interactor
        let presenter = NewChallengePresenter()
        presenter.viewController = self
        interactor.presenter = presenter
    }
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        background = UIColor.JEWBlack()
        keyboardSize = KeyboardService.keyboardSize()
        setup()
        setupView()
        setupChallengeImage()
        setupRecurrency()
        setupLeftButton()
        setupTextFields()
    }
    
    func setupChallengeImage() {
        challengeImageButton.setImage(UIImage(named: "edit"), for: .normal)
        challengeImageButton.tintColor = .JEWBlack()
        challengeImageButton.backgroundColor = .JEWDefault()
        challengeImageButton.setupRounded(borderColor: .white)
    }
    
    func setupRecurrency() {
        recurrencyArray.append(Avaliation.init(text: "S"))
        recurrencyArray.append(Avaliation.init(text: "T"))
        recurrencyArray.append(Avaliation.init(text: "Q"))
        recurrencyArray.append(Avaliation.init(text: "Q"))
        recurrencyArray.append(Avaliation.init(text: "S"))
        recurrencyArray.append(Avaliation.init(text: "S"))
        recurrencyArray.append(Avaliation.init(text: "D"))
        recurrencyArray.append(Avaliation.init(text: "Todos", width: 70))
        recurrencyView.setIndividualSelection(individualSelection: true).setup(avaliations: recurrencyArray)
        recurrencyView.hasSelectedButtonCallback = { (selectedIndex) in
            if selectedIndex == self.recurrencyArray.count - 1 {
                self.recurrencyView.unselectButtons(notUnselectIndex: selectedIndex)
            } else {
                self.recurrencyView.unselectButton(indexButton: self.recurrencyArray.count - 1)
            }
        }
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
    
    func setupTextFields() {
        let challengeNameTextFieldFactory = JEWFloatingTextFieldFactory(withFloatingTextField: challengeNameTextField)
        let challengeNameToolbarBuilder = JEWFloatingTextFieldToolbarBuilder(with: challengeNameTextField).setToolbar(leftButtons: [.cancel], rightButtons: [.ok], shouldShowKeyboard: true)
        let challengeNameFormatBuilder = JEWFloatingTextFieldFormatBuilder(with: challengeNameTextField).setAll(withPlaceholder: "Nome do Objetivo").setTextFieldTextColor(color: .white)
        
        challengeNameTextFieldFactory.setupFormatBuilder(builder: challengeNameFormatBuilder)
            .setupToolbarBuilder(builder: challengeNameToolbarBuilder)
            .setup(buildersType: [.CodeView], delegate: self)
        
        let goalReachTextFieldFactory = JEWFloatingTextFieldFactory(withFloatingTextField: goalReachTextField)
        let goalReachToolbarBuilder = JEWFloatingTextFieldToolbarBuilder(with: goalReachTextField).setToolbar(leftButtons: [.cancel], rightButtons: [.ok], shouldShowKeyboard: true)
        let goalReachFormatBuilder = JEWFloatingTextFieldFormatBuilder(with: goalReachTextField).setAll(withPlaceholder: "Repetições").setKeyboardType(type: .decimalPad).setTextFieldTextColor(color: .white)
        
        goalReachTextFieldFactory.setupFormatBuilder(builder: goalReachFormatBuilder)
            .setupToolbarBuilder(builder: goalReachToolbarBuilder)
            .setup(buildersType: [.CodeView], delegate: self)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "NewChallenge"
    }
    @objc func changeImage(_ sender: Any) {
        self.challengeImageButton.layer.animate()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension NewChallengeViewController: JEWCodeView {
    func buildViewHierarchy() {
        view.addSubview(scrollableStackView)
        challengeNameImageView.translatesAutoresizingMaskIntoConstraints = false
        challengeImageButton.translatesAutoresizingMaskIntoConstraints = false
        scrollableStackView.translatesAutoresizingMaskIntoConstraints = false
        challengeNameTextField.translatesAutoresizingMaskIntoConstraints = false
        recurrencyTitle.translatesAutoresizingMaskIntoConstraints = false
        recurrencyView.translatesAutoresizingMaskIntoConstraints = false
        goalReachTitle.translatesAutoresizingMaskIntoConstraints = false
        goalReachSwitch.translatesAutoresizingMaskIntoConstraints = false
        goalReachAnimation.translatesAutoresizingMaskIntoConstraints = false
        goalReachTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            scrollableStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollableStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollableStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            scrollableStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            challengeImageButton.widthAnchor.constraint(equalToConstant: 150),
            challengeImageButton.heightAnchor.constraint(equalToConstant: 150)
            ])
        
        
        NSLayoutConstraint.activate([
            challengeNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            recurrencyTitle.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        heightRecurrencyViewConstraint = recurrencyView.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([
            heightRecurrencyViewConstraint
        ])
        
        NSLayoutConstraint.activate([
            goalReachTitle.heightAnchor.constraint(equalToConstant: 20)
        ])
        NSLayoutConstraint.activate([
            goalReachStackView.heightAnchor.constraint(equalToConstant: 35)
        ])
        NSLayoutConstraint.activate([
            goalReachSwitch.widthAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            goalReachAnimation.widthAnchor.constraint(equalToConstant: 70)
        ])
        NSLayoutConstraint.activate([
            goalReachTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.layoutIfNeeded()
        recalculateRecurrencyViewHeight()
    }
    
    func recalculateRecurrencyViewHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.heightRecurrencyViewConstraint.constant = self.recurrencyView.collectionView.contentSize.height
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func setupAdditionalConfiguration() {
        challengeImageButton.addTarget(self, action: #selector(changeImage(_:)), for: .touchUpInside)
        recurrencyTitle.text = "Frequência:"
        recurrencyTitle.textColor = UIColor.JEWDefault()
        goalReachTitle.text = "Meta a atingir:"
        goalReachTitle.textColor = UIColor.JEWDefault()
        scrollableStackView.setCustomSpacing(spacing: 16, after: challengeNameTextField)
        goalReachSwitch.tintColor = .JEWDefault()
        goalReachSwitch.onTintColor = .JEWDefault()
        scrollableStackView.setup(subViews: [challengeImageButton, challengeNameTextField, recurrencyTitle, recurrencyView, goalReachTitle, goalReachStackView, goalReachTextField], axis: .vertical, spacing: 4)
        goalReachStackView.setup(subViews: [goalReachSwitch, goalReachAnimation], axis: .horizontal)
        goalReachStackView.stackView.alignment = .center
        setupAnimation()
    }
    
    func setupAnimation() {
        let loadAnimation = Animation.named("infinityLottieOrange", bundle: Bundle(for: type(of: self)))
        goalReachAnimation.animation = loadAnimation
        goalReachAnimation.contentMode = .scaleAspectFit
        goalReachAnimation.animationSpeed = 1.5
        goalReachAnimation.loopMode = .playOnce
        goalReachAnimation.play()
    }
    
    
}

extension NewChallengeViewController: NewChallengeViewControllerProtocol {
    
}

extension NewChallengeViewController: JEWFloatingTextFieldDelegate {
    
    func toolbarAction(_ textField: JEWFloatingTextField, typeOfAction type: JEWKeyboardToolbarButton) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: JEWFloatingTextField) {
        let height = KeyboardService.keyboardHeight()
//        scrollableStackView.scrollToView(view: textField, animated: true)
        let maxYTextField = scrollableStackView.convert(textField.frame.origin, to: self.scrollableStackView).y
        let minYTextField = maxYTextField + textField.frame.height
        let minYKeyboard = view.frame.maxY - height - 50
        if minYTextField > minYKeyboard {
            scrollableStackView.setContentOffset(CGPoint.init(x: 0, y: minYKeyboard - minYTextField + 100), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: JEWFloatingTextField) {
        scrollableStackView.setContentOffset(.zero, animated: true)
    }
    
    
}
