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
    static func uploadPost(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) {
            imageURL in
            let data: [String: Any] = [
                "caption" : caption,
                "timestamp": Timestamp(date: Date()),
                "likes": 0,
                "imageUrl": imageURL,
                "ownerId" : uid
            ]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
}
