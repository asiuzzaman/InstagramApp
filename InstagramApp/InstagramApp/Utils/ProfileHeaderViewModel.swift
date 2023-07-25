//
//  ProfileHeaderViewModel.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 25/7/23.
//

import Foundation


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
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
}
