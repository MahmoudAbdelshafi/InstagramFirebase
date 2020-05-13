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
    
    struct User{
        var username:String
        var profileImageUrl:String
        init(dicionary:[String:Any]) {
            self.username = (dicionary["username"] as! String)
            self.profileImageUrl = (dicionary["profileImageUrl"] as! String)
        }
    }
    
    
    
    //MARK:- properties
    var image:UIImage?
    var username:String?
    
    
    
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileImage()
        
        
    }
   
    
    //MARK:- IBActions
    @IBAction func logOutPressed(_ sender: Any) {
        handelLogOut()
    }
    
    
    
    
}


//MARK:- Private Functions
extension UserProfileController{
    
 
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
    
    
    
    
    
    //get profile image
    fileprivate func setupProfileImage(){
        fetchUser { (urlString) in
            let url = URL(string: urlString!)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                guard let dataImage = UIImage(data: data!) else {return}
                DispatchQueue.main.async {
                    self.image = dataImage
                    self.userCollectionView.reloadData()
                }
                
            }.resume()
        }
        
    }
    
    
    //get image URL from data base
    fileprivate func fetchUser(comletion:@escaping(_ image:String?)->Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            let user = User(dicionary: dictionary)
            self.navigationItem.title = user.username
            self.username = user.username
            comletion(user.profileImageUrl)
        }) { (err) in
            print("failled to fetch user")
        }
        
    }
    
    
    
    
    
}

//MARK:- UserHeader Methods
extension UserProfileController{
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UserProfileHeader", for: indexPath) as! UserProfileHeader
    
        header.userImage.image = image
        header.userLabel.text = username
        return header
    }
    
    
    
    //Header size
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 200)
    }
    
}




//MARK:- User Profile CollectionView Deleget methods
extension UserProfileController : UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
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
