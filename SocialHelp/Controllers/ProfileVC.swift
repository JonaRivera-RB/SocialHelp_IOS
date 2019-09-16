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
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        setUserDataInView()
    }
    
    func setUserDataInView() {
        let userData = Memory.memory.getUserData()
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionLbl.text = "Versión \(appVersion ?? "??") Debug"
        
        self.userNameLbl.text = userData?.name
        self.fullNameLbl.text = "\(userData?.name ?? "") \(userData?.lastName ?? "")"
        self.emailAddressLbl.text = userData?.email
        self.phoneNumberLbl.text = userData?.phoneNumber
        self.memberSinceLbl.text = "Se unió a SocialHelp el " + (userData?.memberSince ?? "")
        
        if userData?.urlPhoto.isEmpty == false && userData?.urlPhoto != "" {
            if let cacheImage = imageCache.object(forKey: userData?.urlPhoto as AnyObject) as? UIImage {
                profileImage.layer.cornerRadius = 20
                profileImage.clipsToBounds = true
                self.profileImage.image = cacheImage
                return
            }
            
            if userData?.urlPhoto.isEmpty == false {
                Storage.storage().reference(forURL: (userData?.urlPhoto)!).getData(maxSize: 10 * 1024 * 1024, completion: { (data, error) in
                    if let error = error?.localizedDescription {
                        print("error al traer imagen", error)
                        self.profileImage.image  = #imageLiteral(resourceName: "addUserToGroup")
                    }
                    else {
                        let image = UIImage(data: data!)
                        self.profileImage.image = image
                        self.imageCache.setObject(image!, forKey: userData?.urlPhoto as AnyObject)
                    }
                })
            }
            else {
                self.profileImage.image  = #imageLiteral(resourceName: "defaultProfileImage")
            }
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
