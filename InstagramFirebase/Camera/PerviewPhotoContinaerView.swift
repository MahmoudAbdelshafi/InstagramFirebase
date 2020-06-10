//
//  PerviewPhotoContinaerView.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/26/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit
import Photos

class PerviewPhotoContinaerView: UIView {
    let saveButton:UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "save_shadow")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handelSaveButton), for: .touchUpInside)
        return button
    }()
    
    let cancelButton:UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "cancel_shadow")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handelCancelButton), for: .touchUpInside)
        return button
    }()
    
    let perviewImageView:UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- Private functions
extension PerviewPhotoContinaerView{
    @objc fileprivate func handelCancelButton(){
        self.removeFromSuperview()
    }
    
    @objc fileprivate func handelSaveButton(){
        guard let perviewImage = perviewImageView.image else {return}
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: perviewImage)
        }) { (success, error) in
            if let error = error {
                print("Failled to save Image",error)
                return
            }
            print("success saved image")
            self.viewSavedMessage()
        }
    }
    
    fileprivate func setupConstraints(){
        addSubview(perviewImageView)
        addSubview(cancelButton)
        addSubview(saveButton)
        saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 30, paddingRight: 0, width: 60, height: 60)
        perviewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width:50, height: 50)
    }
    
    fileprivate func viewSavedMessage(){
        DispatchQueue.main.async {
            let savedLabel = UILabel()
            savedLabel.text = "Saved Successfully"
            savedLabel.textColor = .white
            savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
            savedLabel.numberOfLines = 0
            savedLabel.textAlignment = .center
            savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
            savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
            savedLabel.center = self.center
            
            self.addSubview(savedLabel)
            savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
            UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1 )
            }) { (completed) in
                UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1 )
                }) { (completed) in
                    savedLabel.removeFromSuperview()
                    savedLabel.alpha = 0
                }
            }
        }
    }
}
