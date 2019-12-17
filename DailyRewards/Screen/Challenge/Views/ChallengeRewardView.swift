//
//  ChallengeRewardView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 11/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import UIKit
import JewFeatures
import Lottie

class ChallengeRewardView: UIStackView {

    typealias TextFieldDidBeginEditing = ((JEWFloatingTextField) -> Void)
    typealias TextFieldDidEndEditing = ((JEWFloatingTextField) -> Void)
    typealias SwitchRewardChange = ((Bool) -> Void)
    //Callbacks
    var textFieldDidBeginEditingCallback: TextFieldDidBeginEditing?
    var textFieldDidEndEditingCallback: TextFieldDidEndEditing?
    var switchRewardChangeCallback: SwitchRewardChange?
    public var hasSelectedButtonCallback: ((_ totalIndex: Int, _ index: Int) -> ())?
    
    //UIProperties
    var rewardTitle = UILabel(frame: .zero)
    var rewardStackView = ScrollableStackView(frame: .zero)
    var rewardSwitch = UISwitch(frame: .zero)
    var rewardAnimation = AnimationView(frame: .zero)
    var rewardTypeView = JEWNPSView(frame: .zero)
    var rewardTextField = JEWFloatingTextField(frame: .zero)
    
    //Properties
    var heightRewardTypeViewConstraint = NSLayoutConstraint()
    var rewardType = RewardType.Money
    
    var rewardTypesArray: [Avaliation] = []
    
    //Life cicle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupRewardTypes()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTextField() {
        let rewardTextFieldFactory = JEWFloatingTextFieldFactory(withFloatingTextField: rewardTextField)
        let rewardToolbarBuilder = JEWFloatingTextFieldToolbarBuilder(with: rewardTextField).setToolbar(leftButtons: [.cancel], rightButtons: [.ok], shouldShowKeyboard: true)
        let rewardFormatBuilder = JEWFloatingTextFieldFormatBuilder(with: rewardTextField).setAll(withPlaceholder: rewardType.getTitle()).setKeyboardType(type: rewardType.keyboardType()).setTextFieldTextColor(color: .white).setTextFieldTextColor(color: .white).setTextFieldKeyboardAppearance(appearance: .dark)
        
        rewardTextFieldFactory.setup(buildersType: [.CodeView], delegate: self).setupFormatBuilder(builder: rewardFormatBuilder)
            .setupToolbarBuilder(builder: rewardToolbarBuilder)
    }
    
    func setupRewardTypes() {
        rewardTypesArray.append(Avaliation.init(text: "Dinheiro", width: 80))
        rewardTypesArray.append(Avaliation.init(text: "Viagem", width: 80))
        rewardTypesArray.append(Avaliation.init(text: "Pizza", width: 60))
        rewardTypesArray.append(Avaliation.init(text: "Hamburguer", width: 130))
        rewardTypesArray.append(Avaliation.init(text: "Cerveja", width: 80))
        rewardTypeView.setIndividualSelection(individualSelection: true).setup(avaliations: rewardTypesArray)
        rewardTypeView.hasSelectedButtonCallback = { (selectedIndex) in
            if let hasSelectedButtonCallback = self.hasSelectedButtonCallback {
                hasSelectedButtonCallback(self.rewardTypesArray.count, selectedIndex)
            }
        }
    }
    
    @objc @IBAction func changeReward(_ sender: UISwitch) {
        if let switchRewardChangeCallback = switchRewardChangeCallback {
            switchRewardChangeCallback(sender.isOn)
        }
    }
    
    public func selectType(index: Int) {
        self.rewardType = RewardType(rawValue: index) ?? .Reward
        updateTextFieldInfo()
        endEditing(true)
        rewardTypeView.unselectButtons(selectIndex: index)
    }
    
    public func updateTextFieldInfo() {
        let rewardTextFieldFactory = JEWFloatingTextFieldFactory(withFloatingTextField: rewardTextField)
        let rewardFormatBuilder = JEWFloatingTextFieldFormatBuilder(with: rewardTextField).setAll(withPlaceholder: rewardType.getTitle()).setKeyboardType(type: rewardType.keyboardType()).setTextFieldTextColor(color: .white).setTextFieldTextColor(color: .white).setTextFieldKeyboardAppearance(appearance: .dark).setTextFieldValueType(type:rewardType.valueType())
        rewardTextField.clear()
        rewardTextFieldFactory.setupFormatBuilder(builder: rewardFormatBuilder)
    }
    
}

extension ChallengeRewardView: JEWFloatingTextFieldDelegate {
    
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

extension ChallengeRewardView: JEWCodeView {
    func buildViewHierarchy() {
        setupRewardViews()
        translatesAutoresizingMaskIntoConstraints = false
        rewardTitle.translatesAutoresizingMaskIntoConstraints = false
        rewardStackView.translatesAutoresizingMaskIntoConstraints = false
        rewardSwitch.translatesAutoresizingMaskIntoConstraints = false
        rewardAnimation.translatesAutoresizingMaskIntoConstraints = false
        rewardTypeView.translatesAutoresizingMaskIntoConstraints = false
        rewardTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupRewardViews() {
        axis = .vertical
        spacing = 4
        addArrangedSubview(rewardTitle)
        addArrangedSubview(rewardStackView)
        rewardStackView.setup(subViews: [rewardSwitch, rewardAnimation], axis: .horizontal)
        addArrangedSubview(rewardTypeView)
        addArrangedSubview(rewardTextField)
        setCustomSpacing(16, after: rewardStackView)
        rewardTitle.text = "Recompensa Simbolica:"
        rewardTitle.textColor = UIColor.JEWDefault()
        rewardSwitch.tintColor = .JEWDefault()
        rewardSwitch.onTintColor = .JEWDefault()
        rewardSwitch.addTarget(self, action: #selector(changeReward(_:)), for: .valueChanged)
        
        rewardStackView.stackView.alignment = .center
        rewardTextField.isHidden = true
        rewardTypeView.isHidden = true
        setupRewardAnimation()
        rewardAnimation.play()
    }
    
    func setupRewardAnimation() {
        let loadAnimation = Animation.named(LottieConstants.closeLottieOrange.rawValue, bundle: Bundle(for: type(of: self)))
        rewardAnimation.animation = loadAnimation
        rewardAnimation.contentMode = .scaleAspectFit
        rewardAnimation.animationSpeed = 2
        rewardAnimation.loopMode = .playOnce
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            rewardTitle.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            rewardStackView.heightAnchor.constraint(equalToConstant: 35)
            ])
        NSLayoutConstraint.activate([
            rewardSwitch.widthAnchor.constraint(equalToConstant: 50)
            ])
        NSLayoutConstraint.activate([
            rewardAnimation.widthAnchor.constraint(equalToConstant: 70)
            ])
        NSLayoutConstraint.activate([
            rewardTextField.heightAnchor.constraint(equalToConstant: 50)
            ])
        heightRewardTypeViewConstraint = rewardTypeView.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([
            heightRewardTypeViewConstraint
            ])
        recalculateRewardTypeViewHeight()
    }
    
    func recalculateRewardTypeViewHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.heightRewardTypeViewConstraint.constant = self.rewardTypeView.collectionView.contentSize.height
            self.heightRewardTypeViewConstraint.constant = self.heightRewardTypeViewConstraint.constant + 20
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
                self.rewardTypeView.selectedButton(index: 0)
                self.rewardType = .Money
                self.setupTextField()
            })
        }
    }
    
    func setupAdditionalConfiguration() {
        
    }
    
}
