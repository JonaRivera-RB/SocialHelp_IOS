//
//  User.swift
//  SocialHelp
//
//  Created by Misael Rivera on 8/31/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//
import Foundation
import Firebase

struct User {
  
  let uid: String
  let email: String
  
  init(authData: Firebase.User) {
    uid = authData.uid
    email = authData.email!
  }
  
  init(uid: String, email: String) {
    self.uid = uid
    self.email = email
  }
}
