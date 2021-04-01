//
//  Message.swift
//  Koven
//
//  Created by Adit Sachde on 1/14/21.
//

import MessageKit

struct Message: MessageType {
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
}

struct Sender: SenderType {
    var senderId: String
    
    var displayName: String
}
