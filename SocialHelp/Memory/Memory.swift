//
//  Memory.swift
//  SocialHelp
//
//  Created by Misael Rivera on 7/20/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import Foundation

struct Memory {
    static let memory = Memory()
    public let defaults = UserDefaults.standard
    
    func saveVerificationCode(code:String) {
        defaults.set(code, forKey: "verificationCode")
    }
    
    func savePhonenumber(code:String) {
        defaults.set(code, forKey: "phonenumber")
    }
    
    func saveUserData(userData:UserData) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(userData), forKey:"userData")
    }
    
    
    func getVerificationCode() -> String? {
        
        if let verificationCode = UserDefaults.standard.string(forKey: "verificationCode") {
            return verificationCode
        }
        return nil
    }
    
    func getPhonenumber() -> String? {
        
        if let verificationCode = UserDefaults.standard.string(forKey: "phonenumber") {
            return verificationCode
        }
        return nil
    }
    
    func getUserData() -> UserData? {
          if let data = UserDefaults.standard.value(forKey:"userData") as? Data {
               let userData = try? PropertyListDecoder().decode(UserData.self, from: data)
               return userData
           }
           return nil
       }
       
       func removeUserData() {
           UserDefaults.standard.removeObject(forKey: "userData")
       }
}
