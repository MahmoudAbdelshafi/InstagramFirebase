//
//  HomePostCell.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/16/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit


protocol HomePostCellDelegate {
    func didTapComment(post:Post)
    func didLike(for cell:HomePostCell)
}

class HomePostCell: UICollectionViewCell {
    
    var delegate:HomePostCellDelegate?
    var post:Post?{
        didSet{
            
            guard let imageUrl = post?.imageUrl else {return}
            let likedImage = UIImage(named: "likephoto_selected")
            let unLikedImage = UIImage(named: "like_unselected")
            likeButton.setImage(post?.hasLiked == true ? likedImage  : unLikedImage , for: .normal)
            photoImageView.loadImage(urlString: imageUrl)
            usernameLabel.text = post?.user.username
            guard let profileImageUrl = post?.user.profileImageUrl else {return}
            userPhotoImageView.loadImage(urlString: profileImageUrl)
            setupattributedCaption()
        }
    }
    
    @IBOutlet weak var photoImageView: CustomImageView!
    @IBOutlet weak var userPhotoImageView: CustomImageView!
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
    @IBAction func commentPressed(_ sender: Any) {
        handelComment()
    }
    
    @IBAction func likePressed(_ sender: Any){
        handelLike()
    }
}

//MARK:- Private Functions
extension HomePostCell{
    fileprivate func  setupattributedCaption(){
        guard let post = self.post else {return}
        
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "  \(post.caption)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.black
               ]))
               
               attributedText.append(NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
        let timeAgoDisplay = post.creationDate?.timeAgoDisplay() ?? ""
        attributedText.append(NSMutableAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.gray]))
               
               captionLabel.attributedText = attributedText
    }
    
    fileprivate func setupUI(){
        photoImageView.clipsToBounds = true
        userPhotoImageView.layer.cornerRadius = 40 / 2
       
    }
    
    fileprivate func handelLike(){
        delegate?.didLike(for: self)
        
    }
    
    fileprivate func handelComment(){
        guard let post = self.post else {return}
        delegate?.didTapComment(post: post)
        
       }
}
