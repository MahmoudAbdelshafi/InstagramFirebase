//
//  File.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/13/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit




class PhotoSelectorHeader: UICollectionViewCell {
   
    
   
    let HeaderPhotoImage:UIImageView = {
        let iv = UIImageView()
           iv.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           return iv
       }()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
        
           addSubview(HeaderPhotoImage)
           HeaderPhotoImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
           
       }
    
    
    
    required init?(coder: NSCoder) {
               fatalError("init(coder:) has not been implemented")
           }
}
