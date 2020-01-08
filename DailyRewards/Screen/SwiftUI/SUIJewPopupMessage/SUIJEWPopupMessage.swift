//
//  SUIJEWPopupMessage.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 01/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import JewFeatures
import Combine


class PopupMessageObservable: ObservableObject {
    
    @Published var size: CGSize = CGSize(width: 300, height: 60)
    @Published var title: String = "teste\n"
    @Published var message: String = "teste"
    @Published var allTextOfPopup = NSMutableAttributedString()
    @Published var titleFont: UIFont = .JEW16Bold()
    @Published var messageFont: UIFont = .JEW14()
    @Published var messageColor: UIColor = JEWPopupMessageType.error.messageColor()
    @Published var popupBackgroundColor: UIColor = JEWPopupMessageType.error.backgroundColor()
    @Published var popupType: JEWPopupMessageType = .error
    @Published var shouldShow: Bool = false
    @Published var shouldHideAutomatically = false
    @Published var delegate: SUIJEWPopupMessageDelegate?
}

public protocol SUIJEWPopupMessageDelegate {
    func didFinishDismissPopupMessage(withPopupMessage popupMessage:SUIJEWPopupMessage)
}

public struct SUIJEWPopupMessage: View {
    @ObservedObject var popupMessageObservable = PopupMessageObservable()
    private let topBarHeight = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0 + 66
    
    private let defaultHeight: CGFloat = 60
    private let defaultPadding: CGFloat = 4
    
    public var body: some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: 10)
                .shadow(radius: 10)
                .foregroundColor(Color(self.popupMessageObservable.popupBackgroundColor))
                .frame(width: self.popupMessageObservable.size.width, height: self.popupMessageObservable.size.height)
                .overlay(
                    HStack(alignment: .center, spacing: self.defaultPadding) {
                        SUITextWithAttributedString(title: self.popupMessageObservable.title, titleFont: self.popupMessageObservable.titleFont, message: self.popupMessageObservable.message, messageFont: self.popupMessageObservable.messageFont, color: self.popupMessageObservable.messageColor).padding(.leading).frame(width: self.popupMessageObservable.size.width - self.defaultHeight - self.defaultPadding*2, height: self.popupMessageObservable.size.height, alignment: .leading)
                        Button(action: {
                            self.changePopupPosition()
                        }) {
                            Text("X").bold()
                        }.foregroundColor(Color(self.popupMessageObservable.messageColor)).frame(width: self.defaultHeight, height: self.popupMessageObservable.size.height, alignment: .center)
                })
                .position(CGPoint.init(x: proxy.size.width/2, y: proxy.frame(in: .local).origin.y - self.popupMessageObservable.size.height/2))
                .modifier(MyEffect(y: self.popupMessageObservable.shouldShow ? self.topBarHeight + self.popupMessageObservable.size.height : -self.topBarHeight))
        }
    }
    
    public func show(withTextMessage message:String, title:String = "", popupType: JEWPopupMessageType = .error, shouldHideAutomatically: Bool = true) {
        popupMessageObservable.shouldHideAutomatically = shouldHideAutomatically
        if popupMessageObservable.shouldHideAutomatically {
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
                timer.invalidate()
                self.changePopupPosition()
            }
        }
        popupMessageObservable.popupType = popupType
        popupMessageObservable.messageColor = self.popupMessageObservable.popupType.messageColor()
        popupMessageObservable.popupBackgroundColor = self.popupMessageObservable.popupType.backgroundColor()
        setupMessageAttributed(withTextMessage: message, title: title)
        calculateHeightOfPopup()
        changePopupPosition()
    }
    
    private func setupMessageAttributed(withTextMessage message:String, title:String) {
        popupMessageObservable.title = title
        popupMessageObservable.message = message
        popupMessageObservable.allTextOfPopup = NSMutableAttributedString()
        let titleAttributed = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.font : popupMessageObservable.titleFont])
        let textMessageAttributed = NSAttributedString.init(string: message, attributes: [NSAttributedString.Key.font : popupMessageObservable.messageFont])
        popupMessageObservable.allTextOfPopup.append(titleAttributed)
        popupMessageObservable.allTextOfPopup.append(textMessageAttributed)
        
    }
    
    private func calculateHeightOfPopup() {
        
        let paddings: CGFloat = 24
        let popupWidth = popupMessageObservable.size.width
        let textMessageWidth = popupWidth - paddings
        let estimatedPopupHeight = popupMessageObservable.allTextOfPopup.string.height(withConstrainedWidth: textMessageWidth, font: .JEW16Bold())
        popupMessageObservable.size.height = defaultHeight
        if estimatedPopupHeight > defaultHeight {
            popupMessageObservable.size.height = estimatedPopupHeight
        }
    }
    
    private func changePopupPosition() {
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            self.popupMessageObservable.shouldShow.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.popupMessageObservable.delegate?.didFinishDismissPopupMessage(withPopupMessage: self)
        }
    }
}

struct SUIJEWPopupMessage_Previews: PreviewProvider {
    static var previews: some View {
        SUIJEWPopupMessage()
    }
}


struct MyEffect: GeometryEffect {
    var y: CGFloat = 0
    
    var animatableData: CGFloat {
        get { y }
        set { y = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: 0, y: y))
    }
}
