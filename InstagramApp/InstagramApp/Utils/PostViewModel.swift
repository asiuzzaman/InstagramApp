//
//  PostViewModel.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 30/7/23.
//

import Foundation

struct PostViewModel {
    private let post: Post
    
    var imageUrl: URL? { URL(string: post.imageUrl) }
    
    var caption: String { post.caption }
    
    var likes: Int { post.likes }
    
    
    init(post: Post) {
        self.post = post
    }
}
