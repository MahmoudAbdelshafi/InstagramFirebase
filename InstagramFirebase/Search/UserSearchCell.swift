//
//  UserSearchCell.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/24/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    //MARK:- Properties
    var user:User?{
        didSet{
            guard let imageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: imageUrl)
            userNameLabel.text = user?.username
        }
    }
    
    //MARK:- IBOutlets
    @IBOutlet weak var profileImageView: CustomImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        
        setupUI()
    }
}

//MARK: Private Functions
extension UserSearchCell{
    fileprivate func setupUI(){
        profileImageView.layer.cornerRadius = 50 / 2
    }
}
