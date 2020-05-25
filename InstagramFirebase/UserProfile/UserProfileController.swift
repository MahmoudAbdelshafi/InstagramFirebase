//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/11/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UIViewController {
    
    
    
    
    
    //MARK:- properties
    var imagesData:UIImage?
    var userId:String?
    var user:User?
    var posts = [Post]()
    
    
    
    
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
            
        
      
        
    }
    
    
    //MARK:- IBActions
    @IBAction func logOutPressed(_ sender: Any) {
        handelLogOut()
    }
    
    
    
    
}


//MARK:- Private Functions
extension UserProfileController{
    
    //Get posts
    fileprivate func fetchOrderdPosts(){
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            let user = User(uid: uid, dicionary: ["username" : "Any"])
            let post = Post(user: user, dictionary: dictionary)
            self.posts.insert(post, at: 0)
            // self.posts.append(post)
           self.userCollectionView.reloadData()
        }) { (error) in
            print("failled to get posts",error)
        }
    }
    
    
    //Logout Alert
    fileprivate func handelLogOut(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do{
                try Auth.auth().signOut()
                
                self.presentLogInController()
            }catch{
                print("Error SignOut")
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    //present LogIn Controller
    fileprivate func presentLogInController(){
        let loginController = storyboard?.instantiateViewController(withIdentifier: "logInController") as! LoginController
        let nav = UINavigationController()
        nav.show(loginController, sender: self)
        nav.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(nav, animated: true)
        }
    }
    
    
    
    

    
    
    //get profile image URL from data base
    fileprivate func fetchUser(){
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = user.username
            self.fetchOrderdPosts()
        }
    }
    
    
    
    
    
}

//MARK:- UserHeader Methods
extension UserProfileController{
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UserProfileHeader", for: indexPath) as! UserProfileHeader
        header.imageURlString = user?.profileImageUrl
        header.userLabel.text = user?.username
        return header
    }
    
    
    
    //Header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 200)
    }
    
}




//MARK:- User Profile CollectionView Datasource methods
extension UserProfileController : UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserProfileCollectionViewCell
        let post = posts[indexPath.item].imageUrl
        cell.userImage.loadImage(urlString: post)
        
        //        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
