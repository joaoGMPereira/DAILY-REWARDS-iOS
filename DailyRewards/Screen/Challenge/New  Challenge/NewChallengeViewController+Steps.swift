//
//  NewChallengeViewController+Steps.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 16/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import UIKit
import JewFeatures

extension NewChallengeViewController {
    
    func setStepMovement(stepMovement: NewChallengeStepMovement, periodSelected: Int) {
        switch stepMovement {
        case .close:
            self.dismiss(animated: true, completion: nil)
        break
        case .first:
            setupFirstStep()
        break
        case .second(let direction):
            direction == .next ? nextToSecondStep() : backToSecondStep()
        break
        case .third(let direction):
            direction == .next ? nextToThirdStep() : backToThirdStep()
        break
        case .fourth(let direction):
            if direction == .next && periodSelected == 0 {
                //TODO Move to fifth
                print("next5")
            } else if direction == .next {
                nextToFourthStep()
                print("next4")
            } else {
                //TODO Move BACK to FOURTH
                backToFourthStep()
            }
            
        break
        case .fifth:
        break
        case .sixth:
        break
        case .finish:
        break
        }
    }
    
    func setupFirstStep(animationDuration: CGFloat = 0.3, animationDelay: CGFloat = 0.02) {
        self.nameTextFieldViewCenterXConstraint.constant = 500
        stepSelected = .first
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.titleBold(withText: "Para seu Novo Desafio,\n", color: .white))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Adicione uma foto!", color: .white))
        setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString, animationDuration: animationDuration, animationDelay: animationDelay)
        self.imageViewCenterXConstraint.constant = 0
        self.contentViewHeightConstraint.constant = imageView.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func nextToSecondStep() {
        self.setupFirstStep(animationDuration: 0, animationDelay: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.imageViewCenterXConstraint.constant = -500
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (finished) in
                self.setupSecondStep()
            })
        })
    }
    
    func backToSecondStep() {
        self.challengePeriodViewViewCenterXConstraint.constant = 500
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            self.setupSecondStep()
        })
    }
    
    func setupSecondStep() {
        stepSelected = .second
        let challengeNameToolbarBuilder = JEWFloatingTextFieldToolbarBuilder(with: nameTextFieldView.challengeNameTextField).setToolbar(leftButtons: [.cancel, .back], rightButtons: [.ok], shouldShowKeyboard: true)
        let challengeNameFormatBuilder = JEWFloatingTextFieldFormatBuilder(with: nameTextFieldView.challengeNameTextField).setAll(withPlaceholder: "Nome do Objetivo").setTextFieldTextColor(color: .white).setTextFieldKeyboardAppearance(appearance: .dark)
        nameTextFieldView.setupCustomTextFieldFactory(withToolbarBuilder: challengeNameToolbarBuilder, formatBuilder: challengeNameFormatBuilder)
        
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.titleBold(withText: "Escreva o nome do seu desafio!", color: .white))
        setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
        nameTextFieldViewCenterXConstraint.constant = 0
        self.contentViewHeightConstraint.constant = nameTextFieldView.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func hasChangeChallengeName(type: JEWKeyboardToolbarButton) {
        switch type {
        case .ok:
            //TODO Move to next
            self.nextToThirdStep()
            break
        case .cancel:
            
            break
        case .back:
            self.setupFirstStep()
            break
        }
    }
    
    func nextToThirdStep() {
        self.nameTextFieldViewCenterXConstraint.constant = -500
        setupThirdStep()
    }
    
    func backToThirdStep() {
        self.challengeRecurrencyViewCenterXConstraint.constant = 500
        setupThirdStep()
    }
    
    func setupThirdStep() {
        stepSelected = .third
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.titleBold(withText: "Qual o período\n", color: .white))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "que você deseja selecionar?", color: .white))
        setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
        challengePeriodViewViewCenterXConstraint.constant = 0
        self.contentViewHeightConstraint.constant = challengePeriodView.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func nextToFourthStep() {
        self.challengePeriodViewViewCenterXConstraint.constant = -500
        setupFourthStep()
    }
    
    func backToFourthStep() {
        //TODO
       // self.challengePeriodViewViewCenterXConstraint.constant = -500
        setupFourthStep()
    }
    
    func setupFourthStep() {
        stepSelected = .fourth
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.titleBold(withText: "Quais os dias\n", color: .white))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "que você deseja selecionar?", color: .white))
        setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
        challengeRecurrencyViewCenterXConstraint.constant = 0
        self.contentViewHeightConstraint.constant = challengeRecurrencyView.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func setNewAttributedText(messageMutableAttributedString: NSMutableAttributedString, animationDuration: CGFloat = 0.3, animationDelay: CGFloat = 0.02) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        style.alignment = .center
        style.lineBreakMode = .byWordWrapping
        let range: NSRange = messageMutableAttributedString.mutableString.range(of: messageMutableAttributedString.string)
        messageMutableAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
        resetConstraints()
        messageLabel.attributedString = messageMutableAttributedString
        messageLabel.animationDuration = animationDuration
        messageLabel.animationDelay = animationDelay
        messageLabel.layoutTool.groupType = .char
        if let superWidth = messageLabel.superview?.frame.width {
            let messageLabelWidth = messageLabel.attributedString.width(withConstrainedHeight: messageLabel.intrinsicContentSize.height)
            messageLabelWidthConstraint.constant = messageLabelWidth > superWidth ? superWidth : messageLabelWidth
            messageLabelHeightConstraint.constant = messageLabel.attributedString.height(withConstrainedWidth: messageLabelWidthConstraint.constant)
            view.layoutIfNeeded()
        }
        messageLabel.attributedString.newLabelWith(with: messageLabelWidthConstraint)
        view.layoutIfNeeded()
        messageLabel.startAppearAnimation()
    }
    
    private func resetConstraints() {
        messageLabelWidthConstraint.constant = 0
        messageLabelHeightConstraint.constant = 0
        view.layoutIfNeeded()
    }
}
