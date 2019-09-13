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
}
