//
//  Chats.swift
//  WeKiddo
//
//  Created by Abdul Aziz H on 25/08/19.
//  Copyright © 2019 WeKiddo. All rights reserved.
//

import CodableFirebase
import FirebaseFirestore
import UIKit

public class Room {
    
    public static func createRoom(roomId: String, title: String, member: [String]) {
        guard let code = Preference.profile?.codePhone,
            let phone = Preference.profile?.phoneNumber else {
            return
        }
        
        let username = code + phone
        var members = [username]
        members.append(contentsOf: member)
        
        let room = Conversation(
            documentId: roomId,
            title: title,
            lastWritedChat: nil,
            lastSenderName: nil,
            lastSenderId: nil,
            lastSenderAvatar: nil,
            payload: nil,
            member: members,
            messages: []
        )
        
        let docData = try! FirestoreEncoder().encode(room)
        
        Firestore.firestore().collection("conversation").addDocument(data: docData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    public static func fetchRoomList(_ completion: @escaping([Conversation]) -> Void) {
        guard let code = Preference.profile?.codePhone,
            let phone = Preference.profile?.phoneNumber else {
            return
        }
        
        let username = code + phone
        
        var conversations: [Conversation] = []
        
        Firestore
            .firestore()
            .collection("conversation")
            .whereField("member", arrayContains: username)
            .getDocuments { querySnapshot, error in
                if let err = error {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        var conversation = try! FirestoreDecoder().decode(Conversation.self, from: document.data())
                        conversation.documentId = document.documentID
                        conversations.append(conversation)
                    }
                    
                    completion(conversations)
                }
        }
    }
    
    public static func fetchRoom(documentId: String, _ completion: @escaping(String) -> Void, _ errorCompletion: @escaping() -> Void) {
        Firestore
            .firestore()
            .collection("conversation")
            .whereField("documentId", isEqualTo: documentId)
            .getDocuments { querySnapshot, error in
                if let err = error {
                    print("Error getting documents: \(err)")
                    errorCompletion()
                } else {
                    guard let document = querySnapshot!.documents.first else {
                        errorCompletion()
                        return
                    }
                    
                    completion(document.documentID)
                }
        }
    }    
}
