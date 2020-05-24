//
//  HomePostCell.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/16/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
    
    var post:Post?{
        didSet{
            
            guard let imageUrl = post?.imageUrl else {return}
            photoImageView.loadImage(urlString: imageUrl)
            
        }
    }
    
    @IBOutlet weak var photoImageView: CustomImageView!
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var bookMarkButton: UIButton!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    override func awakeFromNib() {
       
        setupUI()
    }
    
    
    
}

//MARK:- Private Functions
extension HomePostCell{
    fileprivate func setupUI(){
        photoImageView.clipsToBounds = true
        userPhotoImageView.layer.cornerRadius = 40 / 2
        let attributedText = NSMutableAttributedString(string: "Username  ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "some caption text for testing the cell stretching  some caption text for testing the cell stretchingsome caption text for testing the cell stretching", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.black
        ]))
        
        attributedText.append(NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSMutableAttributedString(string: "1 week ago", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.gray]))
        
        captionLabel.attributedText = attributedText
    }
}
