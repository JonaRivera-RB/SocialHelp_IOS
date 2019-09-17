//
//  ViewControllerExtension.swift
//  SocialHelp
//
//  Created by Misael Rivera on 6/1/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit
import SwiftMessages
import Firebase
import FirebaseAuth

extension UIViewController {
    
    //funcion para ocultar el teclado al oprimir cualquier parte de la pantalla en el telefono
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func validadContra( in text: String) -> Bool {
        
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: text)
    }
    
    func validarCorreo(string: String) -> Bool {
        let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let correoTest = NSPredicate(format:"SELF MATCHES %@", email)
        return correoTest.evaluate(with: string)
    }
    
    func mostrarAlerta(paraTitulo titulo: String,paraString string:String) {
        let alerta = UIAlertController(title: titulo, message: string, preferredStyle: .alert)
        let accion = UIAlertAction(title: "ok", style: .default, handler: nil)
        alerta.addAction(accion)
        present(alerta, animated: true, completion: nil)
    }
    
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func mostrarAlertCargando(toTittle tittle:String, toMessage message:String) -> UIAlertController {
        
        let alertaCargando = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        
        let cargandoIndicador = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        cargandoIndicador.hidesWhenStopped = true
        cargandoIndicador.style = UIActivityIndicatorView.Style.gray
        cargandoIndicador.startAnimating();
        
        alertaCargando.view.addSubview(cargandoIndicador)
        present(alertaCargando, animated: true, completion: nil)
        
        return alertaCargando
    }
    
    
    func showAlertError(title:String, body:String){
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.error)
        error.configureDropShadow()
        let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
        error.configureContent(title: title, body: body, iconText: iconText)
        error.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: warningConfig, view: error)
    }
    
    
    func showAlertWarning(title:String, body:String){
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
        warning.configureContent(title: title, body: body, iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        
        SwiftMessages.show(config: warningConfig, view: warning)
    }
    
    func showStatusBarWithTitle(text:String, show:Bool) {
        //if show {
        let status2 = MessageView.viewFromNib(layout: .statusLine)
        status2.backgroundView.backgroundColor = UIColor.green
        status2.bodyLabel?.textColor = UIColor.white
        status2.configureContent(body: text)
        var status2Config = SwiftMessages.defaultConfig
        status2Config.duration = .seconds(seconds: 3)
        status2Config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        status2Config.preferredStatusBarStyle = .lightContent
        SwiftMessages.show(config: status2Config, view: status2)
        //}else {
        //  SwiftMessages.hide()
        //}
    }
    
    func showAlertSuccess(title:String, body:String){
        let success = MessageView.viewFromNib(layout: .cardView)
        success.configureTheme(.success)
        success.configureDropShadow()
        success.configureContent(title: title, body: body)
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .center
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        
        SwiftMessages.show(config: successConfig, view: success)
    }
}

