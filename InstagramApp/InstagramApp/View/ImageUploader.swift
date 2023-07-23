//
//  ImageUploader.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 23/7/23.
//

import FirebaseStorage
import FirebaseAuth
import UIKit

struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping (String) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            print("Couldn't Convert image to data")
            return
        }
        
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/ \(fileName)")
        
        ref.putData(imageData, metadata: nil ) { metaData, error in
            
            if let error = error {
                print("Debug: Failed to upload data error: \(error)")
                return
            }
            
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else {
                    print("Debug: Couldn't get image properly")
                    return
                }
                completion(imageUrl)
                
            }
            
        }
        
        
    }
}
