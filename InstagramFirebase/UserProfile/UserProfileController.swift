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
    var isGridView = true
    var imagesData:UIImage?
    var userId:String?
    var user:User?
    var posts = [Post]()
    
    
    
    
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cell = UINib(nibName: "HomePostCell", bundle: nil)
        userCollectionView.register(cell, forCellWithReuseIdentifier: "HomePostCell")
        fetchUser()
        
        
        
        
    }
    
    
    //MARK:- IBActions
    @IBAction func logOutPressed(_ sender: Any) {
        handelLogOut()
    }
    
    
    
    
}


//MARK:- Private Functions
extension UserProfileController{
    
      //get profile image URL from data base
      fileprivate func fetchUser(){
          let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
          Database.fetchUserWithUID(uid: uid) { (user) in
              self.user = user
              self.navigationItem.title = user.username
              self.fetchOrderdPosts()
          }
      }
      
    
    //Get Posts
    fileprivate func fetchOrderdPosts(){
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let user = self.user else{return}
                let post = Post(user: user, dictionary: dictionary)
                 self.posts.insert(post, at: 0)
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
    
    
    
    
    
    
  
    
    
    
    
}

//MARK:- UserHeader Methods
extension UserProfileController{
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UserProfileHeader", for: indexPath) as! UserProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
    
    
    
    //Header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 200)
    }
    
}




//MARK:- User Profile CollectionView Datasource methods
extension UserProfileController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UserProfileHeaderDelegate{
    //User Profile Header Delegate Methods
    func didChangeToListView() {
        isGridView = false
        userCollectionView.reloadData()
    }
    
    func didChangeToGridView() {
        isGridView = true
        userCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isGridView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserProfileCollectionViewCell
            cell.post = posts[indexPath.item]
           
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePostCell", for: indexPath) as! HomePostCell
         
            cell.post = posts[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView{
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        }else{
            
            let height:CGFloat = 186 + view.frame.width
            return CGSize(width: view.frame.width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
