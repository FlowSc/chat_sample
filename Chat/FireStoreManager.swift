//
//  FireStoreManager.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

typealias FetchResult = (id: String, data: [String: Any])
//typealias ChatResult = (chatId: String, other: String)
typealias ChatThumbnailData = (chatId: String, userName: String, desc: String, content: String, lastDate: String)


struct ChatResult: Codable {
    var chatId: String = ""
    let other: String
    let lastMsg: String
    let lastMsgDate: Date
}

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
    
    func findUser(_ name: String, myId: String, completion: @escaping ([User]) -> ()) {
        
        db.collection("users")
            .whereField("nickname", isGreaterThanOrEqualTo: name)
            .whereField("nickname", isLessThan: name + "z")
            .getDocuments { (snapshot, err) in
                
                guard let snapshot = snapshot else { return }
                let user = try! snapshot.documents.map { doc -> User? in
                    var user = try doc.data(as: User.self)
                    user?.id = doc.documentID
                    return user
                }.compactMap { $0 }.filter { $0.id != myId}
                
                completion(user)
                
            }
        
    }
    
    func addUser(user: User, completion: @escaping (Bool)->()) {
        
        let userCollection = db.collection("users")
        
        userCollection.whereField("email", isEqualTo: user.email)
            .getDocuments { (query, err) in
                
                if let query = query {
                    
                    if query.count == 0 {
                        userCollection.addDocument(data: [
                            "email":user.email,
                            "password":user.password,
                            "nickname":user.nickname,
                            "imageUrl":user.imageUrl,
                            "description":user.description
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
    
    func getChatList(_ userId: String, completion: @escaping (([ChatResult]) -> ())) {
        
        db.collection("chats").whereField("owners", arrayContains: userId).getDocuments { (snapshot, err) in
            
            if let chatList = snapshot?.documents.map({ doc -> ChatResult? in
                
                let id = doc.documentID
                let owners = doc.data()["owners"] as! [String]
                let lastMsg = doc.data()["lastMsg"] as! String
                let lastMsgDate = doc.data()["lastMsgDate"] as! Timestamp
                
                if let others = owners.filter({ $0 != userId}).first {
                    return ChatResult(chatId: id, other: others, lastMsg: lastMsg, lastMsgDate: lastMsgDate.dateValue())
                } else {
                    return nil
                }
            }).compactMap({ $0 }) {
                completion(chatList)
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
    
    func makeChat(_ myId: String, receiverId: String, completion: @escaping (String)->()) {
        
        db.collection("chats").whereField("owners", isEqualTo: [myId, receiverId].sorted())
            .getDocuments { (docs, err) in
                if let _docs = docs {
                    if _docs.count == 0 {
                        let newChatId = self.db.collection("chats").addDocument(data: ["owners": [myId, receiverId].sorted()
                        ]) { err in
                        }.documentID
                        completion(newChatId)
                    } else {
                        if let existed = _docs.documents.map({ $0.documentID }).first {
                            completion(existed)
                        }
                    }
                }
            }
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
    
    func getUser(_ id: String, completion: @escaping (User?)->()) {
        
        db.collection("users").document(id).getDocument { (snapshot, err) in
            if let user = try? snapshot?.data(as: User.self) {
                completion(user)
            } else {
                completion(nil)
            }
        }
        
    }
    
}
