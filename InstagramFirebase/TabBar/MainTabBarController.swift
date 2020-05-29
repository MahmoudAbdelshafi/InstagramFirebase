//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/11/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {

    

   
    
    
    
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var mainTabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setupUI()
        checkIfLogedIn()
       

    }
    

    

}


//MARK:- Private Functions
extension MainTabBarController{
    //Check if logged in method
    fileprivate func checkIfLogedIn(){
        if Auth.auth().currentUser?.uid == nil {
            let loginController = storyboard?.instantiateViewController(withIdentifier: "logInController") as! LoginController 
            let nav = UINavigationController()
            nav.show(loginController, sender: self)
            nav.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
            self.present(nav, animated: true)
            }
        }
        
        
        
        
    }
      fileprivate func setupUI(){
        
        guard let items = tabBar.items else {return}
        for i in items{
            i.imageInsets = UIEdgeInsets(top:2, left: 0, bottom: -2, right: 0)
        }
        
    }

         

}



//MARK:- TabBar Deleget
extension MainTabBarController: UITabBarControllerDelegate{
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2{
       
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let nav = UINavigationController(rootViewController: photoSelectorController)
            nav.modalPresentationStyle = .fullScreen
            
            present(nav, animated: true, completion: nil)
            
            
            return false
           
        }
        return true
    }
    
}
