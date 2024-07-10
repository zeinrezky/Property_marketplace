//
//  Message.swift
//  WeKiddo
//
//  Created by Abdul Aziz H on 23/08/19.
//  Copyright © 2019 WeKiddo. All rights reserved.
//

import FirebaseFirestore
import UIKit

enum MessageType: String {
    case text
    case image
    case audio
}

struct Message: Codable {
    let messageId: String
    let senderId: String
    let senderName: String
    let senderAvatar: String
    let mediaHash: String?
    let payload: String?
    let body: String?
    let type: String
    let date: Double
}
