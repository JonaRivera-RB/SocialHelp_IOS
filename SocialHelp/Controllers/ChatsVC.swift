//
//  NewMessagesVC.swift
//  SocialHelp
//
//  Created by Misael Rivera on 9/13/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit

class ChatsVC: UIViewController, NewChatVCDelegate {
    func showChat(string: String) {
        print("hola")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setView() {
        let containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    @IBAction func NewChatBtnWasPressed(_ sender: Any) {
        
//        let navController = UINavigationController(rootViewController: newChatVC)
//        present(navController, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let newMessageVC:NewChatVC = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! NewChatVC
        newMessageVC.modalPresentationStyle = .fullScreen
        present(newMessageVC, animated: true, completion: nil)
    }
    
    func showChatLong(user : BasicUserData) {
        let chatloggVC = ChatLongVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatloggVC.user = user
        navigationController?.pushViewController(chatloggVC, animated: true)
    }
}
