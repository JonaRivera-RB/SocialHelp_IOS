//
//  VerificateCodeVC.swift
//  SocialHelp
//
//  Created by Misael Rivera on 6/1/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit
import FirebaseAuth


class VerificateCodeVC: UIViewController {

    
    var informationUser:RegisterInformationUser?
    var webServices = WebServices()
    var codeString:String = ""
    
    @IBOutlet weak var userPhonenumberLbl: UILabel!
    @IBOutlet weak var CodeOne: codeDesignTF!
    @IBOutlet weak var codeTwo: codeDesignTF!
    @IBOutlet weak var codeThree: codeDesignTF!
    @IBOutlet weak var codeFour: codeDesignTF!
    @IBOutlet weak var codeFive: codeDesignTF!
    @IBOutlet weak var codeSix: codeDesignTF!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CodeOne.delegate = self
        codeTwo.delegate = self
        codeThree.delegate = self
        codeFour.delegate = self
        codeFive.delegate = self
        codeSix.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        CodeOne.becomeFirstResponder()
    }
    
    @IBAction func signUpBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendCodeBtnWasPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyBtnWasPressed(_ sender: Any) {
        
        if  CodeOne.text  != "", codeTwo.text != "", codeThree.text != "", codeFour.text != "", codeFive.text != "", codeSix.text != "" {
            
            let code:String = "\(CodeOne.text!)\(codeTwo.text!)\(codeThree.text!)\(codeFour.text!)\(codeFive.text!)\(codeSix.text!)"
            
            print("CODE ->\(code)")
            let showAlertLoading = mostrarAlertCargando(toTittle: "verificando code...", toMessage: "Please wait one moment")
            
            webServices.verificateCode(toCredential: code) { (success, error) in
                DispatchQueue.main.async {
                    showAlertLoading.dismiss(animated: true, completion: nil)
                    if success {
                        self.performSegue(withIdentifier: "showRegisterView", sender: Any?.self)
                    }else {
                        self.mostrarAlerta(paraTitulo: "Ups", paraString: error as? String ?? "Intentalo de nuevo mas tarde")
                        print("error al registrar")
                    }
                }
            }
        }
    }
    
}

extension VerificateCodeVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((textField.text?.count)! < 1 ) && (string.count > 0) {
            if textField == CodeOne {
                codeTwo.becomeFirstResponder()
            }
            
            if textField == codeTwo {
                codeThree.becomeFirstResponder()
            }
            
            if textField == codeThree {
                codeFour.becomeFirstResponder()
            }
            
            if textField == codeFour {
                codeFive.becomeFirstResponder()
            }
            if textField == codeFive {
                codeSix.becomeFirstResponder()
            }
            if textField == codeSix {
                codeSix.resignFirstResponder()
            }
            
            textField.text = string
            return false
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            if textField == codeTwo {
                CodeOne.becomeFirstResponder()
            }
            if textField == codeThree {
                codeTwo.becomeFirstResponder()
            }
            if textField == codeFour {
                codeThree.becomeFirstResponder()
            }
            if textField == codeFive {
                codeFour.becomeFirstResponder()
            }
            if textField == codeSix {
                codeFive.becomeFirstResponder()
            }
            if textField == CodeOne {
                CodeOne.resignFirstResponder()
            }
            
            textField.text = ""
            return false
        } else if (textField.text?.count)! >= 1 {
            textField.text = string
            return false
        }
        
        return true
    }
}
