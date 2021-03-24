//
//  ChatListTableViewCell.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/23.
//

import Foundation
import UIKit

final class ChatListTableViewCell: UITableViewCell {
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    private let imv = UIImageView()
    private let nameLb = UILabel()
    private let descLb = UILabel()
    private let chatLb = UILabel()
    private let dateLb = UILabel()
    private let unreadLb = UILabel()
    private let bottomLine = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setAttributes()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imv.image = nil
        self.nameLb.text = nil
        self.descLb.text = nil
        self.dateLb.text = nil
        self.unreadLb.text = nil
        self.chatLb.text = nil
    }
    
    private func setUI() {
        
        self.selectionStyle = .none
        
        self.addSubviews([imv, nameLb, descLb, chatLb, dateLb, unreadLb, bottomLine])
        
        imv.snp.makeConstraints { (make) in
            make.top.leading.equalTo(16)
            make.size.equalTo(40)
        }
                
        nameLb.snp.makeConstraints { (make) in
            make.top.equalTo(imv.snp.top).offset(3)
            make.leading.equalTo(imv.snp.trailing).offset(10)
            make.height.equalTo(16)
        }
        
        descLb.snp.makeConstraints { (make) in
            make.top.equalTo(nameLb.snp.bottom).offset(3)
            make.leading.equalTo(nameLb.snp.leading)
        }
        
        chatLb.snp.makeConstraints { (make) in
            make.top.equalTo(descLb.snp.bottom).offset(5)
            make.leading.equalTo(nameLb.snp.leading)
            make.trailing.equalTo(unreadLb.snp.leading).offset(-10)
        }
        
        unreadLb.snp.makeConstraints { (make) in
            make.centerY.equalTo(chatLb.snp.centerY)
            make.trailing.equalTo(-16)
            make.width.equalTo(25)
            make.height.equalTo(16)
        }
        
        dateLb.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLb.snp.centerY)
            make.trailing.equalTo(-16)
            make.height.equalTo(16)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(chatLb.snp.bottom).offset(20)
            make.leading.equalTo(nameLb.snp.leading)
            make.height.equalTo(1)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

    }
    
    private func setAttributes() {
        
        imv.setBorder(radius: 3, width: 1, color: .clear)
        imv.backgroundColor = UIColor.white233
        bottomLine.backgroundColor = UIColor.white233
        dateLb.textColor = UIColor.white(200)
        nameLb.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        descLb.font = UIFont.systemFont(ofSize: 12)
        chatLb.font = UIFont.systemFont(ofSize: 13)
        dateLb.font = UIFont.systemFont(ofSize: 11)
        dateLb.textAlignment = .right
        
//        unreadLb.backgroundColor = .red
//        unreadLb.font = UIFont.systemFont(ofSize: 11)
//        unreadLb.textColor = .white
//        unreadLb.textAlignment = .center
//        unreadLb.setBorder(radius: 8, width: 1, color: .clear)
        
    }
    
    func setData(_ chat: ChatThumbnail) {
        
        let interval = chat.lastDate.timeIntervalSince1970 - Date().timeIntervalSince1970
        
        if interval > 86400 {
            if interval > 86400 * 2 {
                self.dateLb.text = "\(interval / 86400)일 전"
            } else {
                self.dateLb.text = "어제"
            }
        } else {
            self.dateLb.text = dateFormatter.string(from: chat.lastDate)
        }
        
        
        self.unreadLb.text = chat.unreadCount
        self.imv.setImageFrom(chat.senderImg)
        self.nameLb.text = chat.sender
        self.descLb.text = chat.senderDesc
        self.chatLb.text = chat.lastMsg
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
