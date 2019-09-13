//
//  ResetPasswordVC.swift
//  SocialHelp
//
//  Created by Misael Rivera on 5/27/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func resetMyPasswordBtnWasPressed(_ sender: Any) {
        guard let email = emailTxt.text, email != "" else { return }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                self.popupAlert(title: "Verify your email",message: "An verify email has been sended to your email", actionTitles: ["OK"], actions: [{
                    alertAction in
                    self.navigationController?.popViewController(animated: true)
                    }])
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    @IBAction func backBtnWasPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
