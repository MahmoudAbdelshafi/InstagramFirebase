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
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
        fetchPosts()
         
        
    }
}


//MARK:- Collection View DataSource Methods
extension HomeController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        cell.photoImageView.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 2)
    }
    
    
}



//MARK:- Private functions
extension HomeController{
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        guard let dictionaries = snapshot.value as? [String:Any] else {return}
         dictionaries.forEach { (key,value) in
         guard let dictionary = value as? [String: Any] else{ return}
            let post = Post(dictionary: dictionary)
            self.posts.append(post)
            }
            self.homeCollectionView.reloadData()
        }) { (err) in
            print("err",err)
        }
    }
}
