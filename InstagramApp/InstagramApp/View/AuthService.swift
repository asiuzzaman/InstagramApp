//
//  AuthService.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 23/7/23.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let userName: String
    let fullName: String
    let profileImage: UIImage
}

struct AuthService {
    static func registerUser(withCredentials credential: AuthCredentials, completion: @escaping(Error?) -> Void) {
        
        ImageUploader.uploadImage(image: credential.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credential.email, password: credential.password) { result, error in
                
                if let error = error {
                    print("[AS] Failed to register user: \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                /// prepare data
                
                let data: [String: Any] = [
                    "email": credential.email,
                    "userName": credential.userName,
                    "fullName": credential.fullName,
                    "profileImageUrl": imageUrl,
                    "uid": uid
                ]
                
                print("Ready to upload")
                
                Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                
            }
        }
        
    }
}

