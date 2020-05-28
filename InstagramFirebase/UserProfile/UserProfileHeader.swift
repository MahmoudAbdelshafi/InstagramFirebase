//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/11/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit
import Firebase


protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader: UICollectionReusableView {
    
    //MARK:- Properties
    var delegate:UserProfileHeaderDelegate?
    var numberOfPosts = String()
    var user:User?{
        didSet{
            guard let imageUrl = user?.profileImageUrl else { return }
            userImage.loadImage(urlString: imageUrl)
            userLabel.text = user?.username
            setupEditProfileButton()
        }
    }
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var userImage: CustomImageView!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var gridButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var bookMarkButton: UIButton!
    
   
    override func awakeFromNib() {
        setupUI()
    }
    
    
    //MARK:- IBActions
    @IBAction func editProfilePressed(_ sender: Any) {
        handelEditProfileOrFollow()
    }
    @IBAction func gridPressed(_ sender: Any) {
        handelChangeToGrid()
    }
    @IBAction func listPressed(_ sender: Any) {
        handelChangeToListView()
    }
    @IBAction func bookmarkPressed(_ sender: Any) {
        funchandelChangeToBookmark()
    }
}






//MARK:- Private Functions
extension UserProfileHeader{
    
    fileprivate func handelChangeToListView(){
        print("list")
        listButton.tintColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.6862745098, alpha: 1)
        gridButton.tintColor = .lightGray
        bookMarkButton.tintColor = .lightGray
        delegate?.didChangeToListView()
    }
    
    fileprivate func handelChangeToGrid(){
        listButton.tintColor = .lightGray
        gridButton.tintColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.6862745098, alpha: 1)
        bookMarkButton.tintColor = .lightGray
        delegate?.didChangeToGridView()
    }
    
    
    fileprivate func funchandelChangeToBookmark(){
        listButton.tintColor = .lightGray
        gridButton.tintColor = .lightGray
        bookMarkButton.tintColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.6862745098, alpha: 1)
    }
    
    
    
    fileprivate func setupEditProfileButton(){
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        if currentLoggedInUserId != userId{
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.followStyle()
                }else{
                    self.unFollowStyle()
                }
                
            }) { (error) in
                print(error,"failled to check if following")
            }
            
        }else{
            editProfileButton.setTitle("Edit Prfile", for: .normal)
            editProfileButton.backgroundColor = .clear
        }
    }
    
    
    
    
  
    
    fileprivate func handelEditProfileOrFollow(){
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        
        if editProfileButton.titleLabel?.text == "Follow" {
            //Follow
            let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
            let values = [userId:1]
            ref.updateChildValues(values) { (error, ref) in
                if let err = error{
                    print(err, "following error")
                    return
                }
                self.followStyle()
                print("succssfuly followed user")
            }
        }else{
            //Unfollow
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue { (err, ref) in
                if let err = err{
                    print(err,"error unfollowing")
                    return
                }
                print("Unfollowed")
                self.unFollowStyle()
            }
        }
        
    }
    
    
    fileprivate func unFollowStyle(){
        self.editProfileButton.setTitle("Follow", for: .normal)
        self.editProfileButton.backgroundColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.6862745098, alpha: 1)
        self.editProfileButton.setTitleColor(.white, for: .normal)
    }
    
    fileprivate func followStyle(){
        self.editProfileButton.setTitle("Unfollow", for: .normal)
        self.editProfileButton.backgroundColor = .clear
        self.editProfileButton.setTitleColor(.black, for: .normal)
    }
    
    
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

