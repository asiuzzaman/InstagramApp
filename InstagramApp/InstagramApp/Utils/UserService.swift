//
//  UserService.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 25/7/23.
//

import Firebase

typealias FirestoreCompletion = (Error?)-> Void

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
    
    
    static func fetchUsers(completion: @escaping([User]) -> Void ) {
        
        COLLECTION_USERS.getDocuments { (snapshot, error ) in
            guard let querySnapshot = snapshot else { return }
            
            let users = querySnapshot.documents.map({ User(dictionary: $0.data()) })
            
            completion(users)
            
        }
    }
    
    static func follow(uid: String, completion: @escaping FirestoreCompletion ) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING
            .document(currentUid)
            .collection("user-following")
            .document(uid).setData([:]) {
                error in
                if let error = error  {
                    print("[follow] error \(error.localizedDescription)")
                    return
                }
                
                COLLECTION_FOLLOWERS
                    .document(uid)
                    .collection("user-followers")
                    .document(currentUid) // I guess there will be currentUid
                    .setData([:], completion: completion)
            }
        
    }
    
    static func unfollow(uid: String, completion: @escaping FirestoreCompletion ) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .delete {
                error in
                
                COLLECTION_FOLLOWERS
                    .document(uid)
                    .collection("user-followers")
                    .document(currentUid)
                    .delete(completion: completion)
            }
        
    }
}
