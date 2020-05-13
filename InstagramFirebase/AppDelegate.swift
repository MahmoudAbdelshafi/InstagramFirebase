//
//  AppDelegate.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/10/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }

   


}

