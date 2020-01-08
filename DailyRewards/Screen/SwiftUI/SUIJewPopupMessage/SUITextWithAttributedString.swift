//
//  SUINSAttributedLabel.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 06/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class ViewWithLabel : UIView {
    private var label = UILabel()
    var messageAttributed = NSMutableAttributedString()
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.addSubview(label)
        label.numberOfLines = 0
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setString(_ attributedString:NSAttributedString) {
        self.label.attributedText = attributedString
    }
    
    func setAttributed(withTitle title:String, titleFont: UIFont, message:String, messageFont: UIFont, color: UIColor) {
        messageAttributed = NSMutableAttributedString()
        let titleAttributed = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.font : titleFont])
        let textMessageAttributed = NSAttributedString.init(string: message, attributes: [NSAttributedString.Key.font : messageFont])
        messageAttributed.append(titleAttributed)
        messageAttributed.append(textMessageAttributed)
        self.label.attributedText = messageAttributed
        self.label.textColor = color
    }
}


struct SUITextWithAttributedString: UIViewRepresentable {
    
    var title:String
    var titleFont: UIFont
    var message:String
    var messageFont: UIFont
    var color: UIColor
    
    
    func makeUIView(context: Context) -> ViewWithLabel {
        let view = ViewWithLabel(frame:CGRect.zero)
        return view
    }
    
    func updateUIView(_ uiView: ViewWithLabel, context: UIViewRepresentableContext<SUITextWithAttributedString>) {
        uiView.setAttributed(withTitle: title, titleFont: titleFont, message: message, messageFont: messageFont, color: color)
    }
}
