//
//  CircleButton.swift
//  SocialHelp
//
//  Created by Misael Rivera on 5/28/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit
@IBDesignable

class MiddleCircleButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        circleButton()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        circleButton()
    }
    
    func circleButton() {
        layer.cornerRadius = 10.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.2
    }
}
