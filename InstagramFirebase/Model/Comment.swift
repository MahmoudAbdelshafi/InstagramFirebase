//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/28/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import Foundation


struct Comment {
    var user:User
    let text:String
    let uid:String
    
    init(user:User,dictionary:[String:Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
