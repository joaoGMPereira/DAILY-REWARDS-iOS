//
//  ChallengeImageView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 10/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import UIKit
import JewFeatures

class ChallengeImageView: UIView {
    typealias HasSelectedButton = ((UIButton) -> Void)
    typealias HasSelectedImage = (() -> Void)
    var hasSelectedButtonCallback: HasSelectedButton?
    var hasSelectedImageCallback: HasSelectedImage?
    var challengeImageButton = UIButton(frame: .zero)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChallengeImage()
        setupView()
    }
    
    func setupChallengeImage() {
        challengeImageButton.setImage(UIImage(named: "edit"), for: .normal)
        challengeImageButton.tintColor = .JEWBackground()
        challengeImageButton.backgroundColor = .JEWDefault()
        challengeImageButton.addTarget(self, action: #selector(changeImage(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changeImage(_ sender: Any) {
        self.challengeImageButton.layer.animate()
        if let hasSelectedButtonCallback = hasSelectedButtonCallback {
            hasSelectedButtonCallback(challengeImageButton)
        }
    }
    
    //Show alert
    func showSelectImage(inViewController viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(inViewController: viewController, fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Album de Fotos", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(inViewController: viewController, fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))

        alert.view.tintColor = .JEWDefault()

        if let subview = (alert.view.subviews.first?.subviews.first?.subviews.first) {
             subview.backgroundColor = .JEWBackground()
        }

        viewController.present(alert, animated: true, completion: nil)
    }
    
    //get image from source type
    func getImage(inViewController viewController: UIViewController, fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            viewController.present(imagePickerController, animated: true, completion: nil)
        }
    }
}

extension ChallengeImageView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            challengeImageButton.setImage(image, for: .normal)
            if let hasSelectedImageCallback = hasSelectedImageCallback {
                hasSelectedImageCallback()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ChallengeImageView: JEWCodeView {
    func buildViewHierarchy() {
        addSubview(challengeImageButton)
        translatesAutoresizingMaskIntoConstraints = false
        challengeImageButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            challengeImageButton.widthAnchor.constraint(equalToConstant: 150),
            challengeImageButton.heightAnchor.constraint(equalToConstant: 150),
            challengeImageButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            challengeImageButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 160)
        ])
        layoutIfNeeded()
        challengeImageButton.setupRounded(borderColor: .white)
    }
    
    func setupAdditionalConfiguration() {
        
    }
}
