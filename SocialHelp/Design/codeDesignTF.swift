//
//  codeDesignTF.swift
//  SocialHelp
//
//  Created by Misael Rivera on 7/20/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import UIKit

class codeDesignTF: UITextField {
    private var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func setupView() {
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        self.attributedPlaceholder = placeholder
    }
}
