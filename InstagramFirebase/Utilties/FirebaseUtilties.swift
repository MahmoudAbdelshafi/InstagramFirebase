//
//  FirebaseUtilties.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/24/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUserWithUID(uid:String , completion:@escaping (User) -> ()){
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String:Any] else {return}
            let user = User(uid: uid, dicionary: userDictionary)
            completion(user)
        }) { (error) in
            print(error)
        }
        
    }
}
