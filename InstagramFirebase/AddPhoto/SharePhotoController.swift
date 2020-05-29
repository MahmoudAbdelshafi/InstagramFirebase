//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/13/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController:UIViewController{
    
    
    //MARK:- Properties
    static var selectedImage: UIImage?
    let image = SharePhotoController.selectedImage
    var activityView: UIActivityIndicatorView?
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        setupNavigationBarButtons()
        setupImageAndTextViews()
        self.imageView.image = SharePhotoController.selectedImage
        hideKeyboardWhenTappedAround()
    }
    
    
    override var prefersStatusBarHidden: Bool{
        true
    }
    
    //imageView
    let imageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    //TextView
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
}


//MARK:- Private Functions
extension SharePhotoController{
    
    fileprivate func setupImageAndTextViews(){
        let continarView = UIView()
        continarView.backgroundColor = .white
        view.addSubview(continarView)
        continarView.anchor(top: view.safeAreaLayoutGuide.topAnchor , left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        continarView.addSubview(imageView)
        imageView.anchor(top: continarView.topAnchor, left: continarView.leftAnchor, bottom: continarView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8 , paddingRight: 0, width: 84, height: 0)
        continarView.addSubview(textView)
        textView.anchor(top: continarView.topAnchor, left: imageView.rightAnchor, bottom: continarView.bottomAnchor, right: continarView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        
    }
    
    
    fileprivate func setupNavigationBarButtons(){
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handelShare))
    }
    
    @objc fileprivate func handelShare(){
        saveToStorage()
    }
    
    //Database method
    fileprivate func saveToStorage(){
        showActivityIndicator()
        guard let image = imageView.image else {return}
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else {return}
        let filename = NSUUID().uuidString
        Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error{
                self.hideActivityIndicator()
                print(error)
                return
            }
            print("post saved to storage")
            Storage.storage().reference().child("posts").child(filename).downloadURL { (url, error) in
                if let err = error {
                    self.hideActivityIndicator()
                    print(err.localizedDescription)
                }
                let imageURL = url?.absoluteString
                self.saveToDatabaseWithImageUrl(imageURl: imageURL!)
            }
            
        }
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageURl:String){
        guard let postImage = image  else {return}
        guard let caption = textView.text else {return}
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let postsRef = Database.database().reference().child("posts").child(uid)
        let ref = postsRef.childByAutoId()
        let values = ["imageUrl":imageURl,"caption":caption,"imageWidth":postImage.size.width,"imageHeight": postImage.size.height,"creationDate":Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { (error, ref) in
            if let error = error{
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                 self.hideActivityIndicator()
                print("Can't save to database",error)
            }
             self.hideActivityIndicator()
            self.dismiss(animated: true, completion: nil)
            print("post saved to Database")
            let name = NSNotification.Name(rawValue: "UpdateFeed")
            NotificationCenter.default.post(name: name, object: nil)
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
