//
//  Discussion.swift
//  WeKiddo
//
//  Created by Ferry Irawan on 25/08/19.
//  Copyright © 2019 WeKiddo. All rights reserved.
//

import Firebase
import CodableFirebase
import FirebaseFirestore
import FirebaseStorage
import UIKit

class Discussion {
    
    public static func sendTextMessage(messageValue: String, completion: @escaping() -> Void) {
        guard let code = Preference.profile?.codePhone,
            let phone = Preference.profile?.phoneNumber else {
            return
        }
        
        let username = code + phone
        
        let timeInterval = Date().timeIntervalSince1970
        let message = Message(
            messageId: username+"-\(timeInterval)",
            senderId: username,
            senderName: Preference.profile?.name ?? "",
            senderAvatar: "",
            mediaHash: nil,
            payload: nil,
            body: messageValue,
            type: MessageType.text.rawValue,
            date: timeInterval
        )
        
        let docData = try! FirestoreEncoder().encode(message)
        
        Firestore
            .firestore()
            .collection("conversation")
            .document(PreferenceManager.room)
            .updateData([
                "lastWritedChat": messageValue,
                "lastSenderName": message.senderName,
                "lastSenderId": message.senderId,
                "lastSenderAvatar": message.senderAvatar,
                "messages": FieldValue.arrayUnion([docData])]) { error in
                    if let error = error {
                        print("Error writing document: \(error)")
                    } else {
                        print("Document successfully written!")
                        completion()
                    }
        }
    }
    
    public static func sendImageMessage(messageValue: Data?, completion: @escaping() -> Void) {
        guard let messageValue = messageValue else {
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let interval = Date().timeIntervalSince1970
        let mountainImagesRef = storageRef.child("chat/images/chat_\(interval)")
        
        // Upload the file to the path "images/rivers.jpg"
        mountainImagesRef.putData(messageValue, metadata: nil) { (metadata, error) in
            mountainImagesRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                
                forwardImageChat(imageURL: downloadURL.absoluteString, completion: completion)
            }
        }
    }
    
    static func forwardImageChat(imageURL: String, completion: @escaping() -> Void) {
        guard let code = Preference.profile?.codePhone,
            let phone = Preference.profile?.phoneNumber else {
            return
        }
        
        let username = code + phone
        
        let timeInterval = Date().timeIntervalSince1970
        let message = Message(
            messageId: username + "-\(timeInterval)",
            senderId: username,
            senderName: Preference.profile?.name ?? "",
            senderAvatar: "",
            mediaHash: imageURL,
            payload: nil,
            body: "Sent Image",
            type: MessageType.image.rawValue,
            date: timeInterval
        )
        
        let docData = try! FirestoreEncoder().encode(message)
        
        Firestore
            .firestore()
            .collection("conversation")
            .document(PreferenceManager.room)
            .updateData([
                "lastWritedChat": "Sent Image",
                "lastSenderName": message.senderName,
                "lastSenderId": message.senderId,
                "lastSenderAvatar": message.senderAvatar,
                "messages": FieldValue.arrayUnion([docData])]) { error in
                    if let error = error {
                        print("Error writing document: \(error)")
                    } else {
                        print("Document successfully written!")
                        completion()
                    }
        }
        
    }
    
    public static func sendAudioMessage(messageValue: Data?, completion: @escaping() -> Void) {
        guard let messageValue = messageValue else {
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let interval = Date().timeIntervalSince1970
        let mountainAudioRef = storageRef.child("chat/audio/chat_\(interval)")
        
        // Upload the file to the path "images/rivers.jpg"
        mountainAudioRef.putData(messageValue, metadata: nil) { (metadata, error) in
            mountainAudioRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                
                forwardAudioChat(audioURL: downloadURL.absoluteString, completion: completion)
            }
        }
    }
    
    static func forwardAudioChat(audioURL: String, completion: @escaping() -> Void) {
        guard let code = Preference.profile?.codePhone,
            let phone = Preference.profile?.phoneNumber else {
            return
        }
        
        let username = code + phone
        
        let timeInterval = Date().timeIntervalSince1970
        let message = Message(
            messageId: username + "-\(timeInterval)",
            senderId: username,
            senderName: Preference.profile?.name ?? "",
            senderAvatar: "",
            mediaHash: audioURL,
            payload: nil,
            body: "Sent Voice",
            type: MessageType.audio.rawValue,
            date: timeInterval
        )
        
        let docData = try! FirestoreEncoder().encode(message)
        
        Firestore
            .firestore()
            .collection("conversation")
            .document(PreferenceManager.room)
            .updateData([
                "lastWritedChat": "Sent Audio",
                "lastSenderName": message.senderName,
                "lastSenderId": message.senderId,
                "lastSenderAvatar": message.senderAvatar,
                "messages": FieldValue.arrayUnion([docData])]) { error in
                    if let error = error {
                        print("Error writing document: \(error)")
                    } else {
                        print("Document successfully written!")
                        completion()
                    }
        }
        
    }
    
    static func fetchMessage(_ completion: @escaping(_ message: [Message]) -> Void) {
        Firestore
            .firestore()
            .collection("conversation")
            .document(PreferenceManager.room)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                guard let data = document.data() else {
                    return
                }
                
                let conversation = try! FirestoreDecoder().decode(Conversation.self, from: data)
                completion(conversation.messages)
        }
    }
}
