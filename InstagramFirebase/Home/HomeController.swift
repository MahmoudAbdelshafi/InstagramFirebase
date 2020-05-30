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
    var activityView: UIActivityIndicatorView?
    
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var homeCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let name = NSNotification.Name(rawValue: "UpdateFeed")
        NotificationCenter.default.addObserver(self, selector: #selector(handelUpdateFeed), name: name, object: nil)
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        fetchAllPosts()
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(handelRefresh), for: .valueChanged)
        homeCollectionView.refreshControl = refreshController
        let cell = UINib(nibName: "HomePostCell", bundle: nil)
        homeCollectionView.register(cell, forCellWithReuseIdentifier: "HomePostCell")
       
        
        
            
            
        
        
        
        
    }
    
    //MARK:IBActions
    @IBAction func cameraPressed(_ sender: Any) {
        handelCamera()
    }
    
    
    
}


//MARK:- Collection View DataSource Methods
extension HomeController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HomePostCellDelegate{
   
    //HomePostCell Dealegate methods
    func didLike(for cell: HomePostCell) {
        guard let indexPath = homeCollectionView.indexPath(for:cell) else {return}
        var post = self.posts[indexPath.item]
        guard let postId = post.id else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = [uid:post.hasLiked == true ? 0:1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values ) { (error, _) in
            if let error = error{
                print("error did not submit like",error)
                return
            }
            print("like submitted")
            post.hasLiked = !post.hasLiked
            self.posts[indexPath.item] = post
            self.homeCollectionView.reloadItems(at: [indexPath])
           
        }
    }
    
    func didTapComment(post: Post) {
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePostCell", for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat = 200 + view.frame.width
        return CGSize(width: view.frame.width, height: height)
    }
    
    
}



//MARK:- Private functions
extension HomeController{
    
    
    
    fileprivate func handelCamera(){
        let vc = CameraController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    @objc fileprivate func handelUpdateFeed(){
        handelRefresh()
    }
    
    
    fileprivate func fetchAllPosts(){
        showActivityIndicator()
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    @objc fileprivate func handelRefresh(){
       
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
             self.posts.removeAll()
            self.homeCollectionView.reloadData()
            dictionaries.forEach { (key,value) in
                guard let dictionary = value as? [String: Any] else{ return}
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                guard let uid = Auth.auth().currentUser?.uid else {return}
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                     
                    self.hideActivityIndicator()
                    if let value = snapshot.value as? Int ,value == 1{
                        post.hasLiked = true
                    }else{
                        post.hasLiked = false
                    }
                
                        
                     
                    self.posts.append(post)
                    
                    self.posts.sort { (p1, p2) -> Bool in
                        
                        return p1.creationDate!.compare(p2.creationDate!) == .orderedDescending
                        
                    }
                    self.hideActivityIndicator()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.homeCollectionView.reloadData()
                    }
                }) { (error) in
                     self.hideActivityIndicator()
                    print("failled to fetch like info for posts",error)
                }
                
            }
         
           
        }) { (err) in
            print("err",err)
             self.hideActivityIndicator()
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
