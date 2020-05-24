//
//  UserProfileCollectionViewCell.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/11/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit

class UserProfileCollectionViewCell: UICollectionViewCell {
    var post:Post?{
        didSet{
   
           // cellImage.loadImage(urlString: post!.imageUrl)
            
        }
    }
    
    override func awakeFromNib() {
        
      
//        userImage.clipsToBounds = true
//        userImage.setNeedsDisplay()
       }
       
    
    @IBOutlet weak var userImage: CustomImageView!
    
   
    
}

//MARK:- private Functions
extension UserProfileCollectionViewCell{
    
   
}
