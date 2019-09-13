//
//  CircleDesignButton.swift
//  SocialHelp
//
//  Created by Misael Rivera on 8/28/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit
@IBDesignable

class CircleDesignButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        circleButton()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        circleButton()
    }
    
    func circleButton() {
        layer.cornerRadius = 40.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.2
    }
}
