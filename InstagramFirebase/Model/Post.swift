//
//  Post.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/15/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import Foundation

struct Post {
    let user:User
    let imageUrl: String
    let caption:String

    
    init(user:User,dictionary: [String:Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
