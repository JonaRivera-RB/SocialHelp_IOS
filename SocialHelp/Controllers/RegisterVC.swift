//
//  RegisterVC.swift
//  SocialHelp
//
//  Created by Misael Rivera on 5/27/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var firsNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var genderTxt: UITextField!
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    var informationUser:RegisterInformationUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTxt.text = Memory.memory.getPhonenumber()
        self.hideKeyboardWhenTappedAround()
    }
    @IBAction func createNewAccountBtnWasPressed(_ sender: Any) {
        
        if  firsNameTxt.text != "",
            lastNameTxt.text != "",
            genderTxt.text != "",
            passwordTxt.text != "",
            phoneNumberTxt.text != "",
            confirmPasswordTxt.text != "",
            emailTxt.text != "" {
            if passwordTxt.text == confirmPasswordTxt.text {
                if validarCorreo(string: emailTxt.text!) && validadContra(in: passwordTxt.text!) {
                    informationUser = RegisterInformationUser(firstName: firsNameTxt.text!, lastName: lastNameTxt.text!, gender: genderTxt.text!, phoneNumber: phoneNumberTxt.text!, password: passwordTxt.text!, confirmPassword: confirmPasswordTxt.text!, email: emailTxt.text!)
                    
                }else {
                    self.mostrarAlerta(paraTitulo: "Ups", paraString: "Correo o contraseña no valida, verifica tus datos")
                }
            }else {
                self.mostrarAlerta(paraTitulo: "Ups", paraString: "Las contraseñas no coinciden")
            }
        }
    }
    
    @IBAction func exitBtnWasPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let verificateCode = segue.destination as? VerificateCodeVC {
            verificateCode.informationUser = self.informationUser
        }
    }
}
