//
//  LoginService.swift
//  SocialHelp
//
//  Created by Misael Rivera on 6/1/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

class WebServices {
    static let instance = WebServices()
    
    func login(toEmail email:String, toPassword password:String, loginCompleted: @escaping (_ status:Bool, _ error:Error?) -> () ) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                loginCompleted(false,error)
                return
            }
            
            loginCompleted(true,nil)
        }
    }
    
    func verificateCode(toCredential credential:String, codeVerificated: @escaping (_ status:Bool, _ error:Error?) -> ()) {
        
        let verificationID = Memory.memory.getVerificationCode()
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: credential)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    codeVerificated(false, error)
                    return
                }
                codeVerificated(true,nil)
            }
        }
    }
    
    func registerUser(toEmail email:String, toPassword password:String, toDataUser dataUser:RegisterInformationUser, registerUserCompleted: @escaping (_ status:Bool, _ error:Error?) -> () ) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            print(user!.user.uid)
            guard let user = user else {
                registerUserCompleted(false, error)
                return
            }
            
            let datosUsuario = ["name": dataUser.firstName,
                                "last_name": dataUser.lastName,
                                "gender": dataUser.gender,
                                "phone_number": dataUser.phoneNumber,
                                "password": dataUser.password,
                                "confirm_password": dataUser.confirmPassword,
                                "email": dataUser.email,
                                "id": user.user.uid]
            
            DataServices.instance.createUserDB(uid: user.user.uid, dataUser: datosUsuario as Any as! Dictionary<String, Any>)
            registerUserCompleted(true, nil)
        }
    }
    
}
