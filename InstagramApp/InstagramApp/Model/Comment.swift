//
//  Comment.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 5/8/23.
//

import Firebase

struct Comment {
    
    let commentText: String
    let profileImageUrl: String
    let timestamp: Timestamp
    let userName: String
    let uid: String
    
    init(dictionary: [String: Any] ) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.commentText = dictionary["comment"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.userName = dictionary["userName"] as? String ?? ""
    }
    
    
    
}
