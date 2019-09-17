//
//  NewChatVC.swift
//  SocialHelp
//
//  Created by Misael Rivera on 9/13/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

protocol NewChatVCDelegate {
    func showChat(string: String)
}

class NewChatVC: UIViewController {
    
    @IBOutlet weak var contactsTableView: UITableView!
    var userName:String = ""
    var delegate: NewChatVCDelegate?
    
    var users = [BasicUserData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        checkIfUserIsLoggedIn()
        fetchUser()
        navigationItem.title = userName
    }
    
    func fetchUser() {
        DataServices.instance.REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            for incident in snapshot.children.allObjects as! [DataSnapshot] {
                if let dictionary = incident.value as? [String : AnyObject] {
                    let name = dictionary["name"] as? String
                    let email = dictionary["email"] as? String
                    let urlPhoto = dictionary["photo"] as? String
                    let userID = dictionary["id"] as? String
                    
                    self.users.append(BasicUserData(name: name!, email: email!, urlPhoto: urlPhoto!, userID: userID!))
                }
            }
            DispatchQueue.main.async {
                self.contactsTableView.reloadData()
            }
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else {
            let uid = Auth.auth().currentUser?.uid
            DataServices.instance.REF_USERS.child(uid!).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    self.userName = (dictionary["name"] as? String)!
                }
            }
        }
    }
    
    @objc private func handleLogout() {
        do {
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension NewChatVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newMessageCell", for: indexPath) as! NewMessageCell
        let user = users[indexPath.row]
        cell.updateNewMessageCell(userName: user.name, userEmail: user.email, urlImage: user.urlPhoto)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        dismiss(animated: true) {
            self.delegate?.showChat(string: "Sent from VCFinal")
        }
    }
}
