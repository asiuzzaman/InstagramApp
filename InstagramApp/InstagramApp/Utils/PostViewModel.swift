//
//  PostViewModel.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 30/7/23.
//

import Foundation

struct PostViewModel {
    let post: Post
    
    var imageUrl: URL? { URL(string: post.imageUrl) }
    
    var caption: String { post.caption }
    
    var likes: Int { post.likes }
    
    var userProfileImageUrl: URL? { URL(string: post.ownerImageUrl) }
    
    var userName: String { post.ownerUsername }
    
    var likeLabelText: String {
        if post.likes > 1 {
            return "\(post.likes) likes"
        }
        else {
            return "\(post.likes) like"
        }
    }
    
    init(post: Post) {
        self.post = post
    }
}
