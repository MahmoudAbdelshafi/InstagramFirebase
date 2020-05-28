//
//  User.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/24/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import Foundation

struct User{
    let uid:String
     let username:String
     let profileImageUrl:String?
    init(uid:String,dicionary:[String:Any]) {
         self.username = (dicionary["username"] as? String ?? "")
         self.profileImageUrl = (dicionary["profileImageUrl"] as? String)
        self.uid = uid
     }
 }
