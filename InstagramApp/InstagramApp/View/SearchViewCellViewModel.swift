//
//  SearchViewCellViewModel.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 27/7/23.
//

import Foundation

struct SearchViewCellViewModel {
    private let user: User
    
    var profileImageURL: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var userFullName: String? {
        return user.fullName
    }
    
    var userName: String? {
        return user.userName
    }
    
    init(user: User) {
        self.user = user
    }
}

