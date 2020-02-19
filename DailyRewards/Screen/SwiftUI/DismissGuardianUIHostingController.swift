//
//  DismissGuardianUIHostingController.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 18/02/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import SwiftUI

protocol DismissGuardianDelegate {
    func isPresented(flag: Bool)
    func didUpdate(flag: Bool)
}

class DismissGuardianUIHostingController<Content> : UIHostingController<Content>, UIAdaptivePresentationControllerDelegate where Content : View {
    var preventDismissal: Bool
    var dismissGuardianDelegate: DismissGuardianDelegate?

    init(rootView: Content, preventDismissal: Bool) {
        self.preventDismissal = preventDismissal
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.presentationController?.delegate = self
        
        self.dismissGuardianDelegate?.didUpdate(flag: false)
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        self.dismissGuardianDelegate?.isPresented(flag: false)
    }
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        self.dismissGuardianDelegate?.didUpdate(flag: true)
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return !self.preventDismissal
    }
}
