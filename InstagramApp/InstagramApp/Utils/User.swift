//
//  User.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 25/7/23.
//

import Foundation
import Firebase

struct User {
    let email: String
    let userName: String
    let fullName: String
    let uid: String
    let profileImageUrl: String
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    let isFollowed = false
    
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
