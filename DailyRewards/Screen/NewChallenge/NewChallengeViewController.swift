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
    func displayAllDays(allDaysIndex: Int)
    func hideAllDays(allDaysIndex: Int)
    func displayInfinityGoalReach()
    func displayGoalReach()
}

class NewChallengeViewController: UIViewController {
    
    //MARK: UIProperties
    var scrollableStackView = ScrollableStackView(frame: .zero)
    var challengeImageView = ChallengeImageView(frame: .zero)
    var challengeNameTextFieldView = ChallengeNameTextFieldView(frame: .zero)
    var recurrencyView = RecurrencyView(frame: .zero)
    var goalReachView = GoalReachView(frame: .zero)
    
    //MARK: Properties
    var keyboardSize: CGRect = .zero
    var interactor: NewChallengeInteractorProtocol?
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        background = UIColor.JEWBlack()
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
        let interactor = NewChallengeInteractor()
        self.interactor = interactor
        let presenter = NewChallengePresenter()
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
        challengeNameTextFieldView.textFieldDidBeginEditingCallback = { textField in
            self.moveUpKeyboard(textField: textField)
        }
        
        challengeNameTextFieldView.textFieldDidEndEditingCallback = { textField in
            self.moveDownKeyboard()
        }
        
        goalReachView.textFieldDidBeginEditingCallback = { textField in
            self.moveUpKeyboard(textField: textField)
        }
        
        goalReachView.textFieldDidEndEditingCallback = { textField in
            self.moveDownKeyboard()
        }
        
        recurrencyView.hasSelectedButtonCallback = { (totalIndex, selectedIndex) in
            self.interactor?.hasSelectedButton(totalIndex: totalIndex, selectedIndex: selectedIndex)
        }
        goalReachView.switchGoalReachChangeCallback = { isOn in
            self.interactor?.changeGoalReach(isOn: isOn)
        }
    }
    
}

//MARK: Keyboard methods
extension NewChallengeViewController {
    func moveUpKeyboard(textField: JEWFloatingTextField) {
        let height = KeyboardService.keyboardHeight()
        let minYTextField = self.scrollableStackView.convert(textField.frame.origin, to: self.scrollableStackView).y
        let toolbarHeight: CGFloat = 50
        let maxYTextField = minYTextField + textField.frame.height
        let minYKeyboard = self.view.frame.maxY - height - toolbarHeight
        let moveTextField = maxYTextField - minYKeyboard + toolbarHeight
        if maxYTextField > minYKeyboard {
            self.scrollableStackView.setContentOffset(CGPoint.init(x: 0, y: moveTextField), animated: true)
        }
    }
    
    func moveDownKeyboard() {
        self.scrollableStackView.setContentOffset(.zero, animated: true)
    }
}

//MARK: Actions
extension NewChallengeViewController {
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Display Protocol
extension NewChallengeViewController: NewChallengeViewControllerProtocol {
    
    func displayAllDays(allDaysIndex: Int) {
        self.recurrencyView.unselectButtons(notUnselectIndex: allDaysIndex)
    }
    
    func hideAllDays(allDaysIndex: Int) {
        self.recurrencyView.unselectButton(indexButton: allDaysIndex)
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
    
}

extension NewChallengeViewController: JEWCodeView {
    func buildViewHierarchy() {
        view.addSubview(scrollableStackView)
        scrollableStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            scrollableStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollableStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollableStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            scrollableStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8)
        ])
        
        view.layoutIfNeeded()
    }
    
    func setupAdditionalConfiguration() {
        scrollableStackView.isScrollEnabled = true
        scrollableStackView.setCustomSpacing(spacing: 16, after: challengeNameTextFieldView)
        scrollableStackView.setup(subViews: [challengeImageView, challengeNameTextFieldView, recurrencyView, goalReachView], axis: .vertical, spacing: 4)
    }
    
}
