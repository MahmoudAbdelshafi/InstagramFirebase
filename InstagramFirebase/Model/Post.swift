//
//  Post.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/15/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl: String
    
    init(dictionary: [String:Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
