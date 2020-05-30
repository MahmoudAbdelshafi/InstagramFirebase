//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/11/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    
    
    //MARK:-Properties
    var activityView: UIActivityIndicatorView?
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    //MARK:- IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var goToSignUpButton: UIButton!
    
    
    
    let activityIndicator :UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupUI()
        handelTextInputChange()
        hideKeyboardWhenTappedAround()
                
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func textFields(_ sender: Any) {
        handelTextInputChange()
        
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        HandelLogIn()
    }
    
    @IBAction func goToSignUpPressed(_ sender: Any) {
        let signUpController = storyboard?.instantiateViewController(withIdentifier: "SignUpController") as! SignUpController
        navigationController?.pushViewController(signUpController, animated: true)
        
    }
    
}



//MARK:- Private functions
extension LoginController{
    
    fileprivate func HandelLogIn(){
        guard let email = emailTextField.text, email.count > 0 else {return}
        guard let password = passwordTextField.text, password.count > 0 else {return}
        signInButton.isEnabled = false
        showActivityIndicator()
        Auth.auth().signIn(withEmail: email, password: password) { (auth, error) in
            if let err = error{
                print("Error Signing in", err)
                self.signInButton.isEnabled = true
                self.hideActivityIndicator()
                return
            }
            print("Sign In Succeded")
            self.signInButton.isEnabled = true
            self.hideActivityIndicator()
            let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController
            UIApplication.shared.keyWindow?.rootViewController = mainTabBarController
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //setup buttons UI
    fileprivate func setupUI(){
        signInButton.layer.cornerRadius = 5
        let attributedText = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        attributedText.append(NSMutableAttributedString(string: "Sign Up.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237),]))
        goToSignUpButton.setAttributedTitle(attributedText, for: .normal)
    }
    
    
    //Check for empty fields
    fileprivate func handelTextInputChange(){
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            signInButton.isEnabled = false
            signInButton.backgroundColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.6862745098, alpha: 0.5)
            
        }else{
            signInButton.isEnabled = true
            signInButton.backgroundColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.6862745098, alpha: 1)
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
      
    

   
        
     //MARK: Moving Up the View When keyboard is active
    @objc func keyboardWillShow(sender: NSNotification) {
        if self.view.frame.height < 667{
         self.view.frame.origin.y = -150
        }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 
    }
    
    
    
}
