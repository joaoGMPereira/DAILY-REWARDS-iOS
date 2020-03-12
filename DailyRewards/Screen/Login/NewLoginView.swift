//
//  NewLoginView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 28/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import SwiftUI
import UIKit
import Firebase
import JewFeatures

struct NewLoginView: View, NewLoginViewControllerDelegate {
    //MARK: Properties
    @State var controller: NewLoginViewController?
    var popupMessage = SUIJEWPopupMessage()
    var lottieView = SUILottieView(animationFileName: "IconLottie")
    var signInButton = SUIGoogleButtonSignInView()
    var body: some View {
        ZStack {
            Color.init(UIColor.JEWBackground())
            .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                Text("Daily Rewards").foregroundColor(Color.init(UIColor.JEWDefault())).font(.largeTitle).padding(.bottom, 64.0)
            
                lottieView.frame(width: 150, height: 150, alignment: .center)
                signInButton.frame(width: 240, height: 50, alignment: .center).padding(.top, 64)
            }.padding(.bottom, 100.0)
             popupMessage
        }.onAppear {
            self.showLoading()
            self.controller = NewLoginViewController(with: self)
            self.popupMessage.popupMessageObservable.didDismiss = {

            }
        }
    }
    
    func showLoading() {
        self.lottieView.startAnimation()
        self.signInButton.hide()
    }
    
    func hideLoading() {
        lottieView.stopAnimation()
        signInButton.show()
    }
    
    func showError(withTextMessage message:String, title:String, popupType: JEWPopupMessageType, shouldHideAutomatically: Bool) {
        self.popupMessage.show(withTextMessage: message, title: title, popupType: popupType, shouldHideAutomatically: shouldHideAutomatically)
    }
}

struct NewLoginView_Previews: PreviewProvider {
    static var previews: some View {
        NewLoginView()
    }
}

