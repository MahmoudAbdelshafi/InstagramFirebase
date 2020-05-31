//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/10/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UINavigationControllerDelegate {
    
    
    //MARK:-Properties
    var activityView: UIActivityIndicatorView?
    
    //MARK:- IBOutlets
    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var plusPhotoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

             NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
    }
    
    
    
    
    
    //MARK:- IBActions
    @IBAction func TextFields(_ sender: Any) {
        handelTextInputChange()
    }
    @IBAction func signUpPressed(_ sender: Any) {
        handelSignUp()
    }
    @IBAction func signInPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func plusPhotoButton(_ sender: Any) {
        PlusPhotoButton()
    }
}




//MARK:- Peivate functions
extension SignUpController{
   
    //Handel SignUp
    fileprivate func handelSignUp(){
        guard let email = emailTextFiled.text, email.count > 0 else {return}
        guard let password = passwordTextFiled.text, password.count > 0 else {return}
        guard let username = usernameTextField.text, username.count > 0 else {return}
        signUpButton.isEnabled = false
        showActivityIndicator()
        Auth.auth().createUser(withEmail: email, password: password) { ( user, error) in
            if let err = error{
                print("error signup",err)
                self.signUpButton.isEnabled = true
                self.hideActivityIndicator()
                return
            }
            print("Success Signned Up",user?.user.uid ?? "")
            self.signUpButton.isEnabled = true
            guard let image = self.plusPhotoButton.imageView?.image else {return}
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else {return}
            let filename = NSUUID().uuidString
            Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil) { (metadata, err) in
                if let error = err{
                  self.hideActivityIndicator()
                    self.signUpButton.isEnabled = true
                    print("Error upload profile image" , error)
                    return
                }
                Storage.storage().reference().child("profile_images").child(filename).downloadURL { (url, error) in
                    if let err = error {
                        print(err.localizedDescription)
                        self.signUpButton.isEnabled = true
                    }
                    let profileImageURL = url?.absoluteString
                    guard let uid = user?.user.uid else {return}
                    let dictionaryValues = ["username": username,"profileImageUrl":profileImageURL]
                    let values = [uid:dictionaryValues]
                    Database.database().reference().child("users").updateChildValues(values) { (error, ref) in
                        if error != nil {
                            print("failled to save user info into database")
                            self.signUpButton.isEnabled = true
                            self.hideActivityIndicator()
                        }
                        print("saved to database")
                        self.signUpButton.isEnabled = true
                       self.hideActivityIndicator()
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    //handel changeEdit Text fields
    fileprivate func handelTextInputChange(){
        if emailTextFiled.text!.isEmpty || usernameTextField.text!.isEmpty || passwordTextFiled.text!.isEmpty {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.6862745098, alpha: 0.5)
        }else{
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.6862745098, alpha: 1)
        }
    }
    
    //Setup UI
    fileprivate func setupUI (){
        signUpButton.backgroundColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.6862745098, alpha: 0.5)
        signUpButton.isEnabled = false
        signUpButton.layer.cornerRadius = 5
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.imageView?.contentMode = .scaleAspectFit
        plusPhotoButton.layer.masksToBounds = true
        let attributedText = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.lightGray])
               attributedText.append(NSMutableAttributedString(string: "Sign In.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237),]))
        signInButton.setAttributedTitle(attributedText, for: .normal)
    }
}


//MARK:- Picker view Deleget
extension SignUpController: UIImagePickerControllerDelegate{
    
    //Handel PlusPhotoButton
    fileprivate func PlusPhotoButton(){
        showActivityIndicator()
        let imagePickerController = UIImagePickerController()
 
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: {self.hideActivityIndicator()})
       
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage{
            print(originalImage.size)
            plusPhotoButton.setImage(originalImage, for: .normal)
          
        }
        else if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            plusPhotoButton.setImage(editedImage, for: .normal)
           
        }
        
        dismiss(animated: true, completion: nil)
        setupUI()
        handelTextInputChange()
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
 
    
    
    //MARK: Moving Up the View When keyboard is active
    @objc func keyboardWillShow(sender: NSNotification) {
          if self.view.frame.height < 667{
            self.view.frame.origin.y = -180
          }else{
            self.view.frame.origin.y = -80
        }
           
          
      }

      @objc func keyboardWillHide(sender: NSNotification) {
           self.view.frame.origin.y = 0
      }
    
}
