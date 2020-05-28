//
//  Post.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/15/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import Foundation

struct Post {
    var id:String?
    let user:User
    let imageUrl: String
    let caption:String
    let creationDate:Date?

    
    init(user:User,dictionary: [String:Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
