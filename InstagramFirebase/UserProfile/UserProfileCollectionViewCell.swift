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
            guard let imageUrl = post?.imageUrl else {return}
          userImage.loadImage(urlString: imageUrl)
      
        }
    }
    
    override func awakeFromNib() {
        

       }
       
    
    @IBOutlet weak var userImage: CustomImageView!
    
   
    
}

