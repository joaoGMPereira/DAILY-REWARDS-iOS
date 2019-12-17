//
//  GoalReachView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 11/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import UIKit
import JewFeatures
import Lottie
class ChallengeGoalReachView: UIStackView {
    
    typealias TextFieldDidBeginEditing = ((JEWFloatingTextField) -> Void)
    typealias TextFieldDidEndEditing = ((JEWFloatingTextField) -> Void)
    typealias SwitchGoalReachChange = ((Bool) -> Void)
    var textFieldDidBeginEditingCallback: TextFieldDidBeginEditing?
    var textFieldDidEndEditingCallback: TextFieldDidEndEditing?
    var switchGoalReachChangeCallback: SwitchGoalReachChange?
    
    var goalReachTitle = UILabel(frame: .zero)
    var goalReachStackView = ScrollableStackView(frame: .zero)
    var goalReachSwitch = UISwitch(frame: .zero)
    let goalReachAnimation = AnimationView(frame: .zero)
    var goalReachTextField = JEWFloatingTextField(frame: .zero)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTextField()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTextField() {
        let goalReachTextFieldFactory = JEWFloatingTextFieldFactory(withFloatingTextField: goalReachTextField)
        let goalReachToolbarBuilder = JEWFloatingTextFieldToolbarBuilder(with: goalReachTextField).setToolbar(leftButtons: [.cancel], rightButtons: [.ok], shouldShowKeyboard: true)
        let goalReachFormatBuilder = JEWFloatingTextFieldFormatBuilder(with: goalReachTextField).setAll(withPlaceholder: "Repetições").setKeyboardType(type: .decimalPad).setTextFieldTextColor(color: .white).setTextFieldTextColor(color: .white).setTextFieldKeyboardAppearance(appearance: .dark)
        
        goalReachTextFieldFactory.setupFormatBuilder(builder: goalReachFormatBuilder)
            .setupToolbarBuilder(builder: goalReachToolbarBuilder)
            .setup(buildersType: [.CodeView], delegate: self)
    }
    
    @objc @IBAction func changeGoalReach(_ sender: UISwitch) {
        if let switchGoalReachChangeCallback = switchGoalReachChangeCallback {
            switchGoalReachChangeCallback(sender.isOn)
        }
    }
    
}

extension ChallengeGoalReachView: JEWFloatingTextFieldDelegate {
    
    func toolbarAction(_ textField: JEWFloatingTextField, typeOfAction type: JEWKeyboardToolbarButton) {
        endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: JEWFloatingTextField) {
        if let textFieldDidBeginEditingCallback = textFieldDidBeginEditingCallback {
            textFieldDidBeginEditingCallback(textField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: JEWFloatingTextField) {
        if let textFieldDidEndEditingCallback = textFieldDidEndEditingCallback {
            textFieldDidEndEditingCallback(textField)
        }
    }
    
}

extension ChallengeGoalReachView: JEWCodeView {
    func buildViewHierarchy() {
        setupGoalReachViews()
        translatesAutoresizingMaskIntoConstraints = false
        
        goalReachTitle.translatesAutoresizingMaskIntoConstraints = false
        goalReachStackView.translatesAutoresizingMaskIntoConstraints = false
        goalReachSwitch.translatesAutoresizingMaskIntoConstraints = false
        goalReachAnimation.translatesAutoresizingMaskIntoConstraints = false
        goalReachTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupGoalReachViews() {
        axis = .vertical
        spacing = 4
        addArrangedSubview(goalReachTitle)
        addArrangedSubview(goalReachStackView)
        goalReachStackView.setup(subViews: [goalReachSwitch, goalReachAnimation], axis: .horizontal)
        addArrangedSubview(goalReachTextField)
        goalReachTitle.text = "Meta a atingir:"
        goalReachTitle.textColor = UIColor.JEWDefault()
        goalReachSwitch.tintColor = .JEWDefault()
        goalReachSwitch.onTintColor = .JEWDefault()
        goalReachSwitch.addTarget(self, action: #selector(changeGoalReach(_:)), for: .valueChanged)
        
        goalReachStackView.stackView.alignment = .center
        goalReachTextField.isHidden = true
        setupGoalReachAnimation()
        goalReachAnimation.play()
    }
    
    func setupGoalReachAnimation() {
        let loadAnimation = Animation.named(LottieConstants.infityLoop.rawValue, bundle: Bundle(for: type(of: self)))
        goalReachAnimation.animation = loadAnimation
        goalReachAnimation.contentMode = .scaleAspectFit
        goalReachAnimation.animationSpeed = 3.0
        goalReachAnimation.loopMode = .playOnce
    }
    
    func setupConstraints() {
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
    }
    
    func setupAdditionalConfiguration() {
        
    }
    
}
