//
//  LoginPresenter.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 23/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import UIKit
import JewFeatures

protocol LoginPresenterProtocol {
    func presentLogin(user: JEWUserModel)
    func presentLogin(error: ConnectorError)
}

class LoginPresenter: LoginPresenterProtocol {
    
    var viewController: NewLoginViewControllerProtocol?
    
    func presentLogin(user: JEWUserModel) {
       viewController?.displayLogin(user: user)
    }
    
    func presentLogin(error: ConnectorError) {
        let errorViewData = JEWViewDataErrorContract(error: error)
        viewController?.displayLogin(error: errorViewData.getErrorDescription())
    }
}
