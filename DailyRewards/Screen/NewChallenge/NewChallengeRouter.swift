//
//  NewChallengeRouter.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 03/12/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import UIKit

protocol NewChallengeRouterProtocol: class {
    func openNewChallenge(fromController: UIViewController)
}

class NewChallengeRouter: NSObject, NewChallengeRouterProtocol {
    
    func openNewChallenge(fromController: UIViewController) {
        let viewController = NewChallengeViewController(nibName: "NewChallengeViewController", bundle: Bundle(for: type(of: self)))
        fromController.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
