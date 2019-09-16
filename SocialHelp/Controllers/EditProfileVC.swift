//
//  EditProfileVC.swift
//  SocialHelp
//
//  Created by Misael Rivera on 9/15/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var nameLbl: UITextField!
    @IBOutlet weak var lastNameLbl: UITextField!
    @IBOutlet weak var genderLbl: UITextField!
    @IBOutlet weak var phonenumberLbl: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var verifyPasswordTxt: UITextField!
    @IBOutlet weak var emaillTxt: UITextField!
    @IBOutlet weak var emergencyContactNameTxt: UITextField!
    @IBOutlet weak var emergencyContactPhonenumberTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateDataBtnWasPressed(_ sender: Any) {
    }
    @IBAction func cancelUpdateDataBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func updatePhotoBtnWasPressed(_ sender: Any) {
    }
}
