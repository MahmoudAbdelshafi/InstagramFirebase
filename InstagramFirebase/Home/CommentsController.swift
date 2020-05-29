//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/27/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit
import Firebase





class CommentsController: UICollectionViewController,CommentInputAccessoryViewDelegate {
   
    
   
    
    
    //MARK:- Properties
    
    private let reuseIdentifier = "Cell"
     var post:Post?
    var comments = [Comment]()
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchComments()
        navigationItem.title = "Comments"
        
        collectionView.keyboardDismissMode = .interactive
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0 , left: 0, bottom: -view.safeAreaInsets.bottom  , right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
        // Register cell classes
        self.collectionView!.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        continerView?.removeFromSuperview()
    }
    
    
    
    //Comments ContinerView
    lazy var continerView: CommentInputAccessoryView? = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
  
    }()
    func didSubmit(for comment: String) {
        let postID = post?.id ?? ""
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = ["text":comment, "creationDate": Date().timeIntervalSince1970,"uid":uid] as [String : Any]
        Database.database().reference().child("comments").child(postID).childByAutoId().updateChildValues(values) { (error, ref) in
            if let err = error{
                print(err , "error submitting comment")
            }
            print("comment successfully submitted")
            self.continerView?.clearCommentTextFiled()
        }
       }
    
  
    
    
    override var inputAccessoryView: UIView?{
        get{
         
            return continerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    
   
    
}

// MARK: UICollectionView DataSource
extension CommentsController:UICollectionViewDelegateFlowLayout{

   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        
        cell.comment = comments[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}




//MARK:- Private Functions
extension CommentsController {

    fileprivate func fetchComments(){
        guard let postId = self.post?.id else { return}
    let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            Database.fetchUserWithUID(uid: uid) { (user) in
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView.reloadData()
            }
            
        }) { (error) in
            print(error,"error fetching comments")
        }
        
    }
    
    
    
    
}










// MARK: UICollectionViewDelegate
   
   /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return true
    }
    */
   
   /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
    }
    */
   
   /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
    return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
    return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
