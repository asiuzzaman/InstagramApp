//
//  CommentServices.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 5/8/23.
//

import Firebase

struct CommentService {
    
    static func uploadComment(
        comment: String,
        postID: String,
        user: User,
        completion: @escaping(FirestoreCompletion) 
    ) {
        
        let data: [String: Any] = [
            "uid": user.uid,
            "comment": comment,
            "timestamp": Timestamp(date: Date()),
            "userName": user.userName,
            "profileImageUrl": user.profileImageUrl
        ]
        
        COLLECTION_POSTS
            .document(postID)
            .collection("comments")
            .addDocument(data: data, completion: completion)
        
    }
    
    static func fetchComments() {
        
    }
}
