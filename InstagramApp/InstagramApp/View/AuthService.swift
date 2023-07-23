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
    static func registerUser(withCredentials credential: AuthCredentials) {
        print("Debug: Credential are: \(credential)")
    }
}

