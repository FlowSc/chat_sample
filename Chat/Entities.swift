//
//  Entities.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/23.
//

import Foundation

struct ChatThumbnail: Codable {
    
    let id: String
    let lastDate: String
    let unreadCount: String
    let sender: String
    let senderImg: String
    let senderDesc: String
    let lastMsg: String
    
}

struct User: Codable {
    
    var email: String
    var password: String
    let imageUrl: String
    let nickname: String
    let description: String
    
    var id: String? = ""
    
}

struct Message: Codable {
    var id: String? = ""
    let content: String
    let sender: String
    let senderId: String
    let sendDate: Date
    var isMyMessage: Bool?
}


struct ChatResult: Codable {
    var chatId: String = ""
    let other: String
    let lastMsg: String
    let lastMsgDate: Date
}
