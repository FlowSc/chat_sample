//
//  FireStoreManager.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/21.
//

import Foundation
import FirebaseFirestore

typealias FetchResult = (id: String, data: [String: Any])

class FireStoreManager {
    
    static let shared = FireStoreManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func requestSignIn(_ id: String, pw: String, completion: @escaping (FetchResult?) -> ()) {
        
        db.collection("users").whereField("email", isEqualTo: id).whereField("password", isEqualTo: pw).getDocuments { (snapshot, err) in
            
            guard let snapshot = snapshot else { return }
            
            let fetched = snapshot.documents.map { FetchResult($0.documentID, $0.data())}
            
            if let result = fetched.first {
                completion(result)
            } else {
                completion(nil)
            }
            
        }
        
    }
    
    func findUser(_ name: String, completion: @escaping ([User]) -> ()) {
        
        db.collection("users").whereField("nickname", isGreaterThanOrEqualTo: name)
            .whereField("nickname", isLessThan: name + "z")
            .getDocuments { (snapshot, err) in
                
                guard let snapshot = snapshot else { return }
                
                let users = snapshot.documents.map { document -> User? in
                    let data = document.data()
                    guard let email = data["email"] as? String,
                          let pw = data["password"] as? String,
                          let name = data["nickname"] as? String else { return nil }
                    
                    return User(id: document.documentID, email: email, pw: pw, profileImgUrl: "", name: name, desc: "", chat: nil)
                    
                }.compactMap { $0 }
                
                completion(users)
                
            }
        
    }
    
    func addUser(user: User, completion: @escaping (Bool)->()) {
        
        let userCollection = db.collection("users")
        
        userCollection.whereField("email", isEqualTo: user.email).getDocuments { (query, err) in
            
            if let query = query {
                
                if query.count == 0 {
                    userCollection.addDocument(data: [
                        "email":user.email,
                        "password":user.pw,
                        "nickname":user.name,
                        "imageUrl":user.profileImgUrl,
                        "description":user.desc
                    ]) { (err) in
                        if let _ = err {
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    completion(false)
                }
                
            } else {
                completion(false)
            }
        }
    }
    
    func getChatList(_ id: String, completion: @escaping (([String]) -> ())) {
        
        db.collection("chats").whereField("owners", arrayContains: id).getDocuments { (snapshot, err) in
            if let list = snapshot?.documents.map({ $0.documentID }) {
                completion(list)
            } else {
                completion([])
            }
        }
    }
    
    func getLastChat(_ chatId: String, userId: String, completion: @escaping (Message?) -> ()) {
        
        db.collection("chats/\(chatId)/thread").getDocuments { (snapshot, err) in
            
            if let message = snapshot?.documents.last.map({ doc -> Message? in
                
                print(doc)
                
                guard let name = doc["name"] as? String,
                      let content = doc["content"] as? String
                //                      let id = doc["senderId"] as? String
                else { return nil }
                print(name)
                return Message(id: "1", content: content, date: content, isSended: false)
                
            }) {
                completion(message)
            } else {
                completion(nil)
            }
        }
    }
    
    func makeChat(_ myId: String, receiverId: String, completion: @escaping (Chat)->()) {
        
    }
    
    
    func getChat(_ id: String, completion: @escaping ([Message])->()) {
        
        db.collection("chats/\(id)/thread").getDocuments { (snapshot, err) in
            
            if let msgs = snapshot?.documents.map({ doc -> Message? in
                
                guard let name = doc["name"] as? String,
                      let content = doc["content"] as? String else { return nil }
                
                return Message(id: "1", content: content, date: content, isSended: name == "s")
            }).compactMap({ $0 }) {
                completion(msgs)
            } else {
                completion([])
            }
            
        }
    }
    
}
