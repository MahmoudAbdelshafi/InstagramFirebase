//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/16/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit
import Firebase



class HomeController: UIViewController {
    
    
    
    //MARK:- Properties
    var posts = [Post]()
    
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = NSNotification.Name(rawValue: "UpdateFeed")
        NotificationCenter.default.addObserver(self, selector: #selector(handelUpdateFeed), name: name, object: nil)
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
        fetchAllPosts()
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(handelRefresh), for: .valueChanged)
        homeCollectionView.refreshControl = refreshController
        
    }
    
    
    
}


//MARK:- Collection View DataSource Methods
extension HomeController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomePostCell
        cell.photoImageView.image = nil
        cell.post = posts[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat = 186 + view.frame.width
        return CGSize(width: view.frame.width, height: height)
    }
    
    
}



//MARK:- Private functions
extension HomeController{
    @objc fileprivate func handelUpdateFeed(){
        handelRefresh()
    }
    
    
    fileprivate func fetchAllPosts(){
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    @objc fileprivate func handelRefresh(){
        posts.removeAll()
        fetchAllPosts()
    }
    
    
    fileprivate func fetchFollowingUserIds(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String:Any] else {return}
            userIdsDictionary.forEach { (key,value) in
                Database.fetchUserWithUID(uid: key, completion: self.fetchPostsWithUser(_:))
            }
        }) { (error) in
            print(error,"error getting following users")
        }
        
    }
    
    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid, completion: fetchPostsWithUser(_:))
        
        
    }
    
    fileprivate func fetchPostsWithUser(_ user:User){
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            self.homeCollectionView.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String:Any] else {return}
            dictionaries.forEach { (key,value) in
                guard let dictionary = value as? [String: Any] else{ return}
                let post = Post(user: user, dictionary: dictionary)
                self.posts.append(post)
            }
            self.posts.sort { (p1, p2) -> Bool in
                return p1.creationDate!.compare(p2.creationDate!) == .orderedDescending 
            }
            self.homeCollectionView.reloadData()
        }) { (err) in
            print("err",err)
        }
    }
}
