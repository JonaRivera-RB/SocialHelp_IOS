//
//  sendCodeVC.swift
//  SocialHelp
//
//  Created by Misael Rivera on 7/20/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit
import FirebaseAuth

class sendCodeVC: UIViewController {

    @IBOutlet weak var phoneNumberTxt: codeDesignTF!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func sendCode(){
        
        PhoneAuthProvider.provider().verifyPhoneNumber("+52\(self.phoneNumberTxt.text!)", uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                self.mostrarAlerta(paraTitulo: "Ups", paraString: error.localizedDescription)
                return
            }
            
            Memory.memory.savePhonenumber(code: self.phoneNumberTxt.text!)
            Memory.memory.saveVerificationCode(code: verificationID!)
            self.performSegue(withIdentifier: "showVerificationCode", sender: Any?.self)
        }
    }
    
    @IBAction func sendCodeBtnWasPressed(_ sender: Any) {
        guard let phonenumber = phoneNumberTxt.text, phonenumber != "" else { return }
        
        let alert = UIAlertController(title: "Phone number", message: "it is your phone number? \(phonenumber)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (alert) in
            self.sendCode()
        }
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: {
            self.mostrarAlerta(paraTitulo: "One step more", paraString: "We have sent a verification code a your phone number.")
        })
    }
    @IBAction func backBtnWasPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
