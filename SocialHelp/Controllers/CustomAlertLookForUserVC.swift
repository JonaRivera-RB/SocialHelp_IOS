//
//  CustomAlertLookForUserVC.swift
//  SocialHelp
//
//  Created by Misael Rivera on 9/16/19.







//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit

class CustomAlertLookForUserVC: UIViewController {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var userEmailTxt: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        userEmailTxt.delegate = self
        userEmailTxt.becomeFirstResponder()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(gestureRecognizer:UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        let radius = 15
        let path = UIBezierPath(roundedRect: cancelButton.layer.bounds, byRoundingCorners: [.bottomLeft], cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        cancelButton.layer.mask = mask
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = alertViewGrayColor.cgColor
        
        
        let path2 = UIBezierPath(roundedRect: sendButton.layer.bounds, byRoundingCorners: [.bottomRight], cornerRadii: CGSize(width: radius, height: radius))
        let mask2 = CAShapeLayer()
        mask2.path = path2.cgPath
        sendButton.layer.mask = mask2
        sendButton.layer.borderWidth = 1
        sendButton.layer.borderColor = alertViewGrayColor.cgColor
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendBtnWasPressed(_ sender: Any) {
    }
    
}

extension CustomAlertLookForUserVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
