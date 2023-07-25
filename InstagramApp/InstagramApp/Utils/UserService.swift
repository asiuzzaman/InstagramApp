//
//  UserService.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 25/7/23.
//

import Firebase

struct UserService {
    static func fetchuser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dataDictionary = snapshot?.data() else {
               print("[UserService] Couldn't get Dictonary")
                return
            }
            completion(User(dictionary: dataDictionary))
        }
    }
}
