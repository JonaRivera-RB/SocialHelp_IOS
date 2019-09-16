//
//  ProfileVC.swift
//  SocialHelp
//
//  Created by Misael Rivera on 9/1/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import  GoogleSignIn

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var totalFriendsLbl: UILabel!
    @IBOutlet weak var totalAlertsLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var emailAddressLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var emergencyContactNameLbl: UILabel!
    @IBOutlet weak var emergencyContactPhoneNumberLbl: UILabel!
    @IBOutlet weak var memberSinceLbl: UILabel!
    @IBOutlet weak var versionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionLbl.text = "Versión \(appVersion ?? "??") Debug"
        
        
        let userID = Auth.auth().currentUser?.uid
        print("susurio ID"+userID!)
        DataServices.instance.REF_USERS.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let nombre = value?["name"] as? String
            let last_name = value?["last_name"] as? String
            let email = value?["email"] as? String
            let phone_number = value?["phone_number"] as? String
            let urlPhoto = value?["photo"] as? String
            let memberSince = value?["memberSince"] as? String
            
            self.userNameLbl.text = nombre
            self.fullNameLbl.text = "\(nombre ?? "") \(last_name ?? "")"
            self.emailAddressLbl.text = email
            self.phoneNumberLbl.text = phone_number
            self.memberSinceLbl.text = "Se unió a SocialHelp el " + (memberSince ?? "")
            if urlPhoto?.isEmpty == false {
                Storage.storage().reference(forURL: urlPhoto!).getData(maxSize: 10 * 1024 * 1024, completion: { (data, error) in
                    if let error = error?.localizedDescription {
                        print("error al traer imagen", error)
                        self.profileImage.image  = #imageLiteral(resourceName: "addUserToGroup")
                    }
                    else { self.profileImage.image = UIImage(data: data!) }
                })
            }
            else {
                self.profileImage.image  = #imageLiteral(resourceName: "defaultProfileImage")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    @IBAction func logOutBtnWasPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Estas seguro?", message: "estas apunto de cerrar sesión", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default) { (alerta) in
            try! Auth.auth().signOut()
             GIDSignIn.sharedInstance().signOut()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
         //   let authVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
           // self.present(authVC!, animated: true, completion: nil)
        }
        let alertActionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        alert.addAction(alertActionCancel)
        present(alert, animated: true)
    }
    @IBAction func editProfileBtnWasPressed(_ sender: Any) {
        
        let inicioVC = self.storyboard?.instantiateViewController(withIdentifier: "editProfileVC")
        inicioVC?.modalPresentationStyle = .fullScreen
        self.present(inicioVC!, animated: true, completion: nil)
    }
    
}
