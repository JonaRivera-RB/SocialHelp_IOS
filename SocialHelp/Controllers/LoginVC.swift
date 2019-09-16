//
//  ViewController.swift
//  SocialHelp
//
//  Created by Misael Rivera on 5/27/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginVC: UIViewController, GIDSignInUIDelegate , GIDSignInDelegate  {
    
    var image:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func googleSignInBtnWasPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Fallo logeo con google: ",error)
            return
        }
        
        let alertaCargando = mostrarAlertCargando(toTittle: "Loading", toMessage: "Loading")
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        guard user.profile.imageURL(withDimension: 400) != nil else {return}
        if let urlImage = user.profile.imageURL(withDimension: 400),
            let data = try? Data(contentsOf: urlImage) {
            self.image = UIImage(data: data)
        }
        
        
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if let error = error {
                print("error",error)
                alertaCargando.dismiss(animated: true, completion: {
                    self.mostrarAlerta(paraTitulo: "Error", paraString: "Ocurrió un error al intentar iniciar sesión con google")
                })
                return
            }
            //user is signed in
            //funcion para guardar datos usuario
            guard let uid = user?.user.uid else { return }
            
            DataServices.instance.REF_USERS.child((user?.user.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                let snapshot = snapshot.value as? NSDictionary
                
                if(snapshot == nil)
                {
                    let storage = Storage.storage().reference()
                    let imageName = UUID()
                    let directory = storage.child("imagenesUsuarios/\(imageName)")
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/png"
                    
                    if(self.image != nil) {
                        directory.putData(self.image.pngData()!, metadata: metaData, completion: { (data, error) in
                            if error == nil
                            {
                                self.updateUserDataToFirebase(user: user, directory: "")
                            }
                            if let error = error?.localizedDescription {
                                print("error de firebase",error)
                                alertaCargando.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                    else {
                        self.updateUserDataToFirebase(user: user, directory: "")
                    }
                }
            })
            
            alertaCargando.title = "Descargando datos..."
            self.downloadDataUser { (success) -> () in
                DispatchQueue.main.async {
                    alertaCargando.dismiss(animated: true, completion: nil)
                    if success {
                        alertaCargando.dismiss(animated: true, completion: nil)
                        let inicioVC = self.storyboard?.instantiateViewController(withIdentifier: "InicioVC")
                        inicioVC?.modalPresentationStyle = .fullScreen
                        self.present(inicioVC!, animated: true, completion: nil)
                    }else {
                        self.showAlertError(title: "Ups", body: "Ocurrió un error intentalo de nuevo más tarde.")
                    }
                }
            }
            print("Logeado con exito en firebase con google",uid)
        }
    }
    
    func downloadDataUser(completion: @escaping (_ success:Bool) -> ()) {
        let userID = Auth.auth().currentUser?.uid
        
        DataServices.instance.REF_USERS.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let nombre = value?["name"] as? String
            let last_name = value?["last_name"] as? String
            let email = value?["email"] as? String
            let phone_number = value?["phone_number"] as? String
            let urlPhoto = value?["photo"] as? String
            let memberSince = value?["memberSince"] as? String
            
            let userData:UserData = UserData(name: nombre ?? "", lastName: last_name ?? "", email: email ?? "", phoneNumber: phone_number ?? "", urlPhoto: urlPhoto ?? "", memberSince: memberSince ?? "")
            Memory.memory.saveUserData(userData: userData)
            completion(true)
        }) { (error) in
            completion(false)
            print(error.localizedDescription)
        }
    }
    
    func getDate() -> String{
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        return "\(day ?? 0) \(month ?? 0) de \(year ?? 0)"
    }
    
    func updateUserDataToFirebase(user: AuthDataResult?, directory:String){
        let datosUsuario = ["name": user?.user.displayName,
                            "last_name": "",
                            "gender": "",
                            "phone_number": user?.user.phoneNumber ?? "",
                            "password": "",
                            "confirm_password": "",
                            "email": user?.user.email,
                            "memberSince": self.getDate(),
                            "photo":String(describing:directory),
                            "id": user?.user.uid]
        DataServices.instance.createUserDB(uid: user!.user.uid, dataUser: datosUsuario as Any as! Dictionary<String, Any>)
    }
}
