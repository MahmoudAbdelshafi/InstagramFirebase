//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/24/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UIViewController{
    
    
    //MARK:- Properties
    let cellId = "searchCell"
    private var users = [User]()
    private var filterdUsers = [User]()
    lazy var searchBar:UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter Username"
        sb.delegate = self
        return sb
    }()
    
    //MARK:- IBOutlets
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController()
        fetchUsers()
        hideKeyboardWhenTappedAround()
        searchCollectionView.keyboardDismissMode = .onDrag
        
    }
   
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchBar.isHidden = false
    }
    
    
    
}

//MARK:- collectionView DataSource
extension UserSearchController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterdUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filterdUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
    
}

//MARK:- CollectionView Deleget
extension UserSearchController{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = filterdUsers[indexPath.item]
        print(user.username)
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        let userProfileController = storyboard?.instantiateViewController(withIdentifier: "userProfileController") as! UserProfileController
        userProfileController.userId = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
}

//MARK:- Private functions
extension UserSearchController{
    fileprivate func fetchUsers(){
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String:Any] else {return}
            dictionaries.forEach { (key,value) in
                if key == Auth.auth().currentUser?.uid{
                    return
                }
                guard let userDictionary = value as? [String:Any] else {return}
                let user = User(uid: key, dicionary: userDictionary)
                self.users.append(user)
            }
            self.users.sort { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            }
            self.searchCollectionView.reloadData()
            
        }) { (error) in
            print(error)
        }
        
    }
    
    
    
}
//MARK:- UISearchBar Delegate
extension UserSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            filterdUsers = users
        }else{
            filterdUsers = self.users.filter { (user) -> Bool in
                user.username.lowercased().contains(searchText.lowercased())
            }
            
        }
        
        self.searchCollectionView.reloadData()
    }
    
    fileprivate func setupNavController(){
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
}
