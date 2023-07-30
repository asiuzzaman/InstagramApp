//
//  ProfileHeaderViewModel.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 25/7/23.
//

import UIKit


struct ProfileHeaderViewModel {
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var fullName : String {
        return user.fullName
    }
    
    var userName: String {
        return user.userName
    }
    
    var followButtonText: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackgroudColor: UIColor {
        return user.isCurrentUser ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return user.isCurrentUser ? .black : .white
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var numberOfFollowers: NSAttributedString {
        return attributedStatText(value: user.stats.follower, label: "Followers")
    }
    
    var numberOfFollowing: NSAttributedString {
        return attributedStatText(value: user.stats.following, label: "Following")
    }
    
    // Send default 5 we have to change it
    var numberOfPosts: NSAttributedString {
        return attributedStatText(value: user.stats.posts, label: "Posts")
    }
    
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
    
}
