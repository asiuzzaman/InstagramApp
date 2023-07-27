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
    
}
