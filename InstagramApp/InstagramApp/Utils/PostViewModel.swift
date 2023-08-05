//
//  PostViewModel.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 30/7/23.
//

import UIKit

struct PostViewModel {
    var post: Post
    
    var imageUrl: URL? { URL(string: post.imageUrl) }
    
    var caption: String { post.caption }
    
    var likes: Int { post.likes }
    
    var userProfileImageUrl: URL? { URL(string: post.ownerImageUrl) }
    
    var userName: String { post.ownerUsername }
    
    var likeButtonTintColor: UIColor {
        return post.didLike ? .red : .black
    }
    
    var likeButtonImage: UIImage? {
        let imageName = post.didLike ? "like_selected" : "like_unselected"
        return UIImage(named: imageName)
    }
    
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
