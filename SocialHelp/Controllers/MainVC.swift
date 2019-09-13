//
//  MainVC.swift
//  SocialHelp
//
//  Created by Misael Rivera on 6/2/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    
    
    var scrollViewController: ScrollViewController!
    
    @IBOutlet weak var navigationView: NavigationView!
    
    lazy var alertVC: UIViewController! = {
        return self.storyboard?.instantiateViewController(withIdentifier: "AlertVC")
    }()
    
    lazy var mapVC: UIViewController! = {
        return self.storyboard?.instantiateViewController(withIdentifier: "MapVC")
    }()
    
    lazy var chatVC: UIViewController! = {
        return self.storyboard?.instantiateViewController(withIdentifier: "ChatVC")
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ScrollViewController {
            scrollViewController = controller
            scrollViewController.delegate = self
        }
    }
}
    extension MainVC : ScrollViewControllerDelegate {
        var viewControllers: [UIViewController?] {
            return [alertVC, mapVC,chatVC]
        }
        
        var inicialviewController: UIViewController {
            return mapVC
        }
        
        func scrollViewDidScroll() {
            let min : CGFloat = 0
            let max : CGFloat = scrollViewController.pageSize.width
            let x = scrollViewController.scrollView.contentOffset.x
            
            let result = ((x - min) / (max - min)) - 1
            
            var controller:UIViewController?
            
            if scrollViewController.estaVisibleController(alertVC) {
                controller = alertVC
                
            } else if scrollViewController.estaVisibleController(mapVC) {
                controller = mapVC
            }
            else if scrollViewController.estaVisibleController(chatVC) {
                controller = chatVC
            }
        }
    }
