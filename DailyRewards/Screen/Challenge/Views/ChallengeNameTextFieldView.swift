//
//  ChallengeNameTextFieldView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 11/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import UIKit
import JewFeatures

class ChallengeNameTextFieldView: UIView {
    typealias TextFieldDidBeginEditing = ((JEWFloatingTextField) -> Void)
    typealias TextFieldDidEndEditing = ((JEWFloatingTextField) -> Void)
    typealias TextFieldToolbarAction = ((JEWKeyboardToolbarButton) -> Void)
    
    var challengeNameTextField = JEWFloatingTextField(frame: .zero)
    var textFieldDidBeginEditingCallback: TextFieldDidBeginEditing?
    var textFieldDidEndEditingCallback: TextFieldDidEndEditing?
    var textFieldToolbarActionCallback: TextFieldToolbarAction?
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setupTextField()
    }
    
    func setupTextField() {
        let challengeNameTextFieldFactory = JEWFloatingTextFieldFactory(withFloatingTextField: challengeNameTextField)
        let challengeNameToolbarBuilder = JEWFloatingTextFieldToolbarBuilder(with: challengeNameTextField).setToolbar(leftButtons: [.cancel], rightButtons: [.ok], shouldShowKeyboard: true)
        let challengeNameFormatBuilder = JEWFloatingTextFieldFormatBuilder(with: challengeNameTextField).setAll(withPlaceholder: "Nome do Objetivo").setTextFieldTextColor(color: .white).setTextFieldKeyboardAppearance(appearance: .dark)
        
        challengeNameTextFieldFactory.setupFormatBuilder(builder: challengeNameFormatBuilder)
            .setupToolbarBuilder(builder: challengeNameToolbarBuilder)
            .setup(buildersType: [.CodeView], delegate: self)
    }
    
    func setupCustomTextFieldFactory(withToolbarBuilder toolbarBuilder: JEWFloatingTextFieldToolbarBuilder, formatBuilder: JEWFloatingTextFieldFormatBuilder) {
        let challengeNameTextFieldFactory = JEWFloatingTextFieldFactory(withFloatingTextField: challengeNameTextField)
        
        challengeNameTextFieldFactory.setup(buildersType: [.CodeView], delegate: self).setupFormatBuilder(builder: formatBuilder)
            .setupToolbarBuilder(builder: toolbarBuilder)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChallengeNameTextFieldView: JEWFloatingTextFieldDelegate {
    
    func toolbarAction(_ textField: JEWFloatingTextField, typeOfAction type: JEWKeyboardToolbarButton) {
        endEditing(true)
        if let textFieldToolbarActionCallback = textFieldToolbarActionCallback {
            textFieldToolbarActionCallback(type)
        }
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

extension ChallengeNameTextFieldView: JEWCodeView {
    func buildViewHierarchy() {
        addSubview(challengeNameTextField)
        translatesAutoresizingMaskIntoConstraints = false
        challengeNameTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            challengeNameTextField.topAnchor.constraint(equalTo: topAnchor),
            challengeNameTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
            challengeNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            challengeNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        
    }
    
    func setupAdditionalConfiguration() {
        
    }
    
    
}
