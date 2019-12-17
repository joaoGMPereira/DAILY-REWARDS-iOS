//
//  EditChallengeViewController.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 03/12/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import UIKit
import JewFeatures
import Lottie
import PodAsset

protocol EditChallengeViewControllerProtocol: class {
    func displayRecurrency(selectedIndex: Int)
    func displayPeriod(selectedIndex: Int)
    func displayRecurrency()
    func hideRecurrency()
    func displayInfinityGoalReach()
    func displayGoalReach()
    func displayNoReward()
    func displayReward()
    func displayRewardType(selectedIndex: Int)
}

class EditChallengeViewController: UIViewController {
    
    //MARK: UIProperties
    var scrollableStackView = ScrollableStackView(frame: .zero)
    var challengeImageView = ChallengeImageView(frame: .zero)
    var challengeNameTextFieldView = ChallengeNameTextFieldView(frame: .zero)
    var recurrencyView = ChallengeRecurrencyView(frame: .zero)
    var periodView = ChallengePeriodView(frame: .zero)
    var goalReachView = ChallengeGoalReachView(frame: .zero)
    var rewardView = ChallengeRewardView(frame: .zero)
    
    
    //MARK: Properties
    var keyboardSize: CGRect = .zero
    var interactor: EditChallengeInteractorProtocol?
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        background = UIColor.JEWBackground()
        keyboardSize = KeyboardService.keyboardSize()
        setup()
        setupView()
        setupLeftButton()
        callBacks()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Editar Desafio"
    }
    
    //MARK: Setup
    func setup() {
        let interactor = EditChallengeInteractor()
        self.interactor = interactor
        let presenter = EditChallengePresenter()
        presenter.viewController = self
        interactor.presenter = presenter
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
    
    func callBacks() {
        
        challengeImageView.hasSelectedButtonCallback = { button in
            self.challengeImageView.showSelectImage(inViewController: self)
        }
        
        challengeNameTextFieldView.textFieldDidBeginEditingCallback = { textField in
            self.moveUpKeyboard(textField: textField, superView: self.challengeNameTextFieldView)
        }
        
        challengeNameTextFieldView.textFieldDidEndEditingCallback = { textField in
            self.moveDownKeyboard()
        }
        
        goalReachView.textFieldDidBeginEditingCallback = { textField in
            self.moveUpKeyboard(textField: textField, superView: self.goalReachView)
        }
        
        goalReachView.textFieldDidEndEditingCallback = { textField in
            self.moveDownKeyboard()
        }
        
        recurrencyView.hasSelectedButtonCallback = { (totalIndex, selectedIndex) in
            self.interactor?.changeGoalHasSelectedButton(totalIndex: totalIndex, selectedIndex: selectedIndex)
        }
        
        periodView.hasSelectedButtonCallback = { (totalIndex, selectedIndex) in
            self.interactor?.periodHasSelectedButton(totalIndex: totalIndex, selectedIndex: selectedIndex)
        }
        
        goalReachView.switchGoalReachChangeCallback = { isOn in
            self.interactor?.changeGoalReach(isOn: isOn)
        }
        
        rewardView.textFieldDidBeginEditingCallback = { textField in
            self.moveUpKeyboard(textField: textField, superView: self.rewardView)
        }
        
        rewardView.textFieldDidEndEditingCallback = { textField in
            self.moveDownKeyboard()
        }
        
        rewardView.switchRewardChangeCallback = { isOn in
            self.interactor?.changeReward(isOn: isOn)
        }
        
        rewardView.hasSelectedButtonCallback = { (totalIndex, selectedIndex) in
            self.interactor?.rewardHasSelectedButton(totalIndex: totalIndex, selectedIndex: selectedIndex)
        }
    }
    
}

//MARK: Keyboard methods
extension EditChallengeViewController {
    func moveUpKeyboard(textField: JEWFloatingTextField, superView: UIView) {
        let height = KeyboardService.keyboardHeight()
        let minYTextField = superView.convert(textField.frame.origin, to: self.scrollableStackView).y
        let toolbarHeight: CGFloat = 50
        let maxYTextField = minYTextField + textField.frame.height
        let minYKeyboard = self.view.frame.maxY - height - toolbarHeight
        let moveTextField = maxYTextField - minYKeyboard + toolbarHeight
        self.scrollableStackView.contentInset.bottom = height
        if maxYTextField > minYKeyboard {
            self.scrollableStackView.setContentOffset(CGPoint.init(x: 0, y: moveTextField), animated: true)
        }
    }
    
    func moveDownKeyboard() {
        self.scrollableStackView.contentInset = .zero
    }
}

//MARK: Actions
extension EditChallengeViewController {
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Display Protocol
extension EditChallengeViewController: EditChallengeViewControllerProtocol {

    func displayRecurrency(selectedIndex: Int) {
        self.recurrencyView.selected(index: selectedIndex)
    }
    
    func displayPeriod(selectedIndex: Int) {
        self.periodView.selectType(index: selectedIndex)
    }
    
    func hideRecurrency() {
        self.recurrencyView.isHidden = true
    }
    
    func displayRecurrency() {
        self.recurrencyView.isHidden = false
    }
    
    func displayInfinityGoalReach() {
        goalReachView.goalReachTextField.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.goalReachView.goalReachAnimation.alpha = 1
            self.goalReachView.goalReachAnimation.play()
        }
    }
    
    func displayGoalReach() {
        goalReachView.goalReachTextField.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.goalReachView.goalReachAnimation.alpha = 0
        }
    }
    
    func displayReward() {
        rewardView.rewardTextField.isHidden = false
        rewardView.rewardTypeView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.rewardView.rewardAnimation.alpha = 0
        }
    }
    
    func displayNoReward() {
        rewardView.rewardTextField.isHidden = true
        rewardView.rewardTypeView.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.rewardView.rewardAnimation.alpha = 1
            self.rewardView.rewardAnimation.play()
        }
    }
    
    func displayRewardType(selectedIndex: Int) {
        self.rewardView.selectType(index: selectedIndex)
    }
}

extension EditChallengeViewController: JEWCodeView {
    func buildViewHierarchy() {
        view.addSubview(scrollableStackView)
        scrollableStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            scrollableStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollableStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollableStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            scrollableStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
        
        view.layoutIfNeeded()
    }
    
    func setupAdditionalConfiguration() {
        scrollableStackView.isScrollEnabled = true
        scrollableStackView.setup(subViews: [challengeImageView, challengeNameTextFieldView, recurrencyView, periodView, goalReachView, rewardView], axis: .vertical, spacing: 16, alwaysBounce: true)
        scrollableStackView.setCustomSpacing(spacing: 32, after: challengeNameTextFieldView)
    }
    
}
