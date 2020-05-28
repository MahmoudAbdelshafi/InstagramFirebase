//
//  CommentCell.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/28/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    
    //MARK:- Properties
    var comment:Comment?{
        didSet{
            textView.text = comment?.text
            guard let imageUrl =  comment?.user.profileImageUrl else {return}
            profileImageView.loadImage(urlString: imageUrl)
            guard let username = comment?.user.username else {return}
            let attrbuitedText = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            attrbuitedText.append(NSMutableAttributedString(string: " " + comment!.text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            textView.attributedText = attrbuitedText
        }
    }

    
    
    let textView:UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
   
        
        return textView
    }()
    
    
    let profileImageView:CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 40/2
        image.backgroundColor = .blue
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textView)
        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop:8 , paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        textView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
