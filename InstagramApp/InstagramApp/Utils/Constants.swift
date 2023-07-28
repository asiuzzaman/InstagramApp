//
//  Constants.swift
//  InstagramApp
//
//  Created by Md. Asiuzzaman on 25/7/23.
//

import Firebase

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")