//
//  PostServices.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 30/7/23.
//

import Foundation
import UIKit
import Firebase

struct PostServices {
    
    static func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FirestoreCompletion)) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) {
            imageURL in
            let data: [String: Any] = [
                "caption" : caption,
                "timestamp": Timestamp(date: Date()),
                "likes": 0,
                "imageUrl": imageURL,
                "ownerId" : uid,
                "ownerUsername": user.userName,
                "ownerImageUrl": user.profileImageUrl
            ]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> Void ) {
        
        COLLECTION_POSTS.order(by: "timestamp").getDocuments { (snapshot, error ) in
            guard let querySnapshot = snapshot else { return }
            
            let posts = querySnapshot.documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            completion(posts)
            
        }
    }
    
}
