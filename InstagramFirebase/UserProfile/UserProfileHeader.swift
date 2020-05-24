//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/11/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionReusableView {
    
    var numberOfPosts = String()
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
    override func awakeFromNib() {
        setupUI()
    }

    
    //MARK:- IBActions
    @IBAction func editProfilePressed(_ sender: Any) {
    }
    
}



//MARK:- Private Functions

extension UserProfileHeader{
    fileprivate func setupUI(){
        userImage.layer.cornerRadius = 80/2
        userImage.clipsToBounds = true
        userImage.backgroundColor = .lightGray
        editProfileButton.layer.borderWidth = 0.2
        editProfileButton.layer.cornerRadius = 3
        setupTextLabelAttributes()
    }
    
    //Labels Attributes
    fileprivate func setupTextLabelAttributes(){
        let attributedText = NSMutableAttributedString(string: "\(numberOfPosts)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "Posts", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        postsLabel.attributedText = attributedText
        
        let attributedText1 = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText1.append(NSMutableAttributedString(string: "Followers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        followersLabel.attributedText = attributedText1
        
        
        let attributedText2 = NSMutableAttributedString(string: "11\n ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText2.append(NSMutableAttributedString(string: "Following", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        followingLabel.attributedText = attributedText2
    }
    
    
}
