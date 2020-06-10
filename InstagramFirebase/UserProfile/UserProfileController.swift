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
    var activityView: UIActivityIndicatorView?
    var numberOfPosts = [Post]()
    var isFinishedPagining = false
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

//MARK:- UserHeader Methods
extension UserProfileController{
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UserProfileHeader", for: indexPath) as! UserProfileHeader
        header.user = user
        header.delegate = self
        header.numberOfPosts = numberOfPosts.count
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
        
        if indexPath.item == self.posts.count - 1 && !isFinishedPagining{
            paginatePosts()
        }
        
        if isGridView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserProfileCollectionViewCell
            cell.userImage.image = nil
            cell.post = posts[indexPath.item]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePostCell", for: indexPath) as! HomePostCell
            cell.photoImageView.image = nil
            cell.post = posts[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView{
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        }else{
            let height:CGFloat = 250 + view.frame.width
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

//MARK:- Private Functions
extension UserProfileController{
    
    fileprivate func paginatePosts(){
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        //var query = ref.queryOrderedByKey()
        var query = ref.queryOrdered(byChild: "creationDate")
        if posts.count > 0{
            let value = posts.last?.creationDate?.timeIntervalSince1970
            query = query.queryEnding(atValue: value)
        }
        showActivityIndicator()
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot)  in
            guard  var allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
            allObjects.reverse()
            if allObjects.count < 4 && allObjects.count > 0{
                self.isFinishedPagining = true
            }
            if self.posts.count > 0 {
                allObjects.removeFirst()
            }
            guard let user =  self.user else {return}
            allObjects.forEach({ (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else {return}
                var post = Post(user:user , dictionary: dictionary)
                post .id = snapshot.key
                self.posts.append(post)
            })
            //            self.posts.forEach { (post) in
            //
            //            }
            self.hideActivityIndicator()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.userCollectionView.reloadData()
            }
        }) { (error) in
            print("Pagining Error",error)
            self.hideActivityIndicator()
        }
        
    }
    
    //get profile image URL from data base
    fileprivate func fetchUser(){
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = user.username
            self.getPostsNumber()
            self.paginatePosts()
            //self.fetchOrderdPosts()
        }
    }
    
    //fetchOrderdPosts
    fileprivate func getPostsNumber(){
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let user = self.user else{return}
            let post = Post(user: user, dictionary: dictionary)
            self.numberOfPosts.insert(post, at: 0)
            print(self.numberOfPosts.count)
            //            self.userCollectionView.reloadData()
        }) { (error) in
            print("failled to get posts",error)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.userCollectionView.reloadData()
        }
    }
    
    //Logout Alert
    fileprivate func handelLogOut(){
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do{
                self.showActivityIndicator()
                try Auth.auth().signOut()
                
                self.presentLogInController()
            }catch{
                self.hideActivityIndicator()
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
            self.hideActivityIndicator()
            self.present(nav, animated: true)
        }
    }
    
    fileprivate func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .gray)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    fileprivate func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
}
