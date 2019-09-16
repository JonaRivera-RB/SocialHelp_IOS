//
//  Message.swift
//  SocialHelp
//
//  Created by Misael Rivera on 9/13/19.
//  Copyright © 2019 Misael Rivera. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class Message {
    var fromId = ""
    var name = ""
    var text = ""
    var timestamp = ""
    var toId = ""
    
    init(fromId:String, name:String, text:String, timestamp:String, toId:String) {
        self.fromId = fromId
        self.name = name
        self.text = text
        self.timestamp = timestamp
        self.toId = toId
    }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
