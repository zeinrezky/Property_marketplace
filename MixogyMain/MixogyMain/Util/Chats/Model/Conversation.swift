//
//  Conversation.swift
//  WeKiddo
//
//  Created by Ferry Irawan on 21/08/19.
//  Copyright © 2019 WeKiddo. All rights reserved.
//

import Foundation
import CodableFirebase
import FirebaseFirestore

extension Timestamp: TimestampType {}

extension Date {
    func currentTimestamp() -> Timestamp {
        return Timestamp(date: self)
    }
}

public struct Conversation: Codable {
    var documentId: String
    let title: String
    let lastWritedChat: String?
    let lastSenderName: String?
    let lastSenderId: String?
    let lastSenderAvatar: String?
    let payload: String?
    let member: [String]
    let messages: [Message]
    
    func setSelected() {
        PreferenceManager.room = documentId
    }
}
