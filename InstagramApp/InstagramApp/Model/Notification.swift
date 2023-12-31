//
//  Notification.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 6/8/23.
//

import Firebase

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var notificationMessage : String {
        switch self {
        case .like: return " liked your post"
        case .comment: return " commented on your post"
        case .follow: return " started following you"
        }
    }
}

struct Notification {
    let uid: String
    let postImageUrl: String?
    let timestamp: Timestamp
    let postId: String?
    let type: NotificationType
    let id: String
    let userProfileImageUrl: String
    let username: String
    var userIsFollowed = false
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.userProfileImageUrl = dictionary["userProfileImageUrl"] as? String ?? ""
        self.username = dictionary["username"]  as? String ?? " "
        
    }
}
