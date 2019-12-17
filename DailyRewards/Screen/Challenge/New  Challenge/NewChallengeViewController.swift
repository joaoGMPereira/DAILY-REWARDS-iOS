//
//  NewChallengeViewController.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 13/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import UIKit
import JewFeatures
import ZCAnimatedLabel

class NewChallengeViewController: UIViewController {
    //MARK: UI Properties
    var messageLabel = ZCAnimatedLabel(frame: .zero)
    var contentView = UIView(frame: .zero)
    var challengeButtonsView = ChallengeButtonsView(frame: .zero)
    var imageView = ChallengeImageView(frame: .zero)
    var nameTextFieldView = ChallengeNameTextFieldView(frame: .zero)
    var challengeRecurrencyView = ChallengeRecurrencyView(frame: .zero)
    var challengePeriodView = ChallengePeriodView(frame: .zero)
    
    //MARK: Properties
    var periodSelected: Int?
    var stepSelected: NewChallengeStep = .first
    
    //MARK: Constraints
    var messageLabelWidthConstraint = NSLayoutConstraint()
    var messageLabelHeightConstraint = NSLayoutConstraint()
    
    var contentViewHeightConstraint = NSLayoutConstraint()
    var imageViewCenterXConstraint = NSLayoutConstraint()
    var nameTextFieldViewCenterXConstraint = NSLayoutConstraint()
    var challengeRecurrencyViewCenterXConstraint = NSLayoutConstraint()
    var challengePeriodViewViewCenterXConstraint = NSLayoutConstraint()
    
    //MARK: Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Challenge"
        setupView()
        setupLeftButton()
        callbacks()
        setupFirstStep()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    @objc func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Callbacks
extension NewChallengeViewController {
    func callbacks() {
        imageView.hasSelectedButtonCallback = { button in
            self.imageView.showSelectImage(inViewController: self)
        }
        
        imageView.hasSelectedImageCallback = {
           // self.hasSelectedImage()
        }
        
        nameTextFieldView.textFieldToolbarActionCallback = { type in
            self.hasChangeChallengeName(type: type)
        }
        
        challengePeriodView.hasSelectedButtonCallback = { totalIndexes, selectedIndex in
            self.challengePeriodView.selectType(index: selectedIndex)
            self.periodSelected = selectedIndex
        }
        
        challengeButtonsView.hasSelectedButtonCallback = { selectedIndex in
            var stepMovement = self.stepSelected.moveStep(buttonIndex: selectedIndex)
            self.setStepMovement(stepMovement: stepMovement, periodSelected: self.periodSelected ?? 0)
        }
        
        challengeRecurrencyView.hasSelectedButtonCallback = { totalIndexes, selectedIndex in
            
        }
    }
}

extension NewChallengeViewController: JEWCodeView {
    func buildViewHierarchy() {
        view.addSubview(messageLabel)
        view.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(nameTextFieldView)
        contentView.addSubview(challengeRecurrencyView)
        contentView.addSubview(challengePeriodView)
        view.addSubview(challengeButtonsView)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        messageLabelWidthConstraint = messageLabel.widthAnchor.constraint(equalToConstant: 0)
        messageLabelHeightConstraint = messageLabel.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            messageLabelWidthConstraint,
            messageLabelHeightConstraint,
            messageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            ])
        contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 200)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contentViewHeightConstraint
            ])
        
        NSLayoutConstraint.activate([
            challengeButtonsView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16),
            challengeButtonsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            challengeButtonsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            ])
        
        imageViewCenterXConstraint = imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 500)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageViewCenterXConstraint,
            imageView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 32)])
        
        nameTextFieldViewCenterXConstraint = nameTextFieldView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 500)
        NSLayoutConstraint.activate([
            nameTextFieldView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameTextFieldViewCenterXConstraint,
            nameTextFieldView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 32)])
        
        challengePeriodViewViewCenterXConstraint = challengePeriodView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 500)
        NSLayoutConstraint.activate([
            challengePeriodView.topAnchor.constraint(equalTo: contentView.topAnchor),
            challengePeriodViewViewCenterXConstraint,
            challengePeriodView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 32)])
        
        challengeRecurrencyViewCenterXConstraint = challengeRecurrencyView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 500)
        NSLayoutConstraint.activate([
            challengeRecurrencyView.topAnchor.constraint(equalTo: contentView.topAnchor),
            challengeRecurrencyViewCenterXConstraint,
            challengeRecurrencyView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 32)])

    }
    
    func setupAdditionalConfiguration() {
        background = UIColor.JEWBackground()
        challengeButtonsView.setup(titles: ["Voltar", "Próximo"], backgroundColors: [UIColor.JEWDarkDefault(),UIColor.JEWDefault()])
    }
}
