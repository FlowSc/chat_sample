//
//  ChatListViewController.swift
//  Rocket_Chat
//
//  Created by Kang Seongchan on 2021/03/19.
//

import UIKit

class ChatListViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private(set) var chatList: [ChatThumbnail] = []
        
    private(set) var myInfo: User?
    
    @objc func moveToNewMessage() {
        
        let newChatVc = NewChatViewController()
        
        newChatVc.myId = myInfo!.id!
        
        self.navigationController?.pushViewController(newChatVc, animated: true)
        
        
    }
    
    func setUser(_ result: User) {
        
        self.myInfo = result
        
        FireStoreManager.shared.getChatList(result.id!) { (list) in
            list.forEach { (chat) in
                FireStoreManager.shared.getUser(chat.other) { (user) in
                    guard let user = user else { return }
                    let chatThumbnail = ChatThumbnail(id: chat.chatId, lastDate: "", unreadCount: "", sender: user.nickname, senderImg: user.imageUrl, lastMsg: chat.lastMsg)
                    self.chatList.append(chatThumbnail)
                    if list.count == self.chatList.count {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func logOut() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTableView()
    }
    
    private func setUI() {
        
        self.title = "메시지"
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let newMsgBtn = UIBarButtonItem(title: "새 메시지", style: .plain, target: self, action: #selector(moveToNewMessage))
        let logOutBtn = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(logOut))
        
        self.navigationItem.rightBarButtonItem = newMsgBtn
        self.navigationItem.leftBarButtonItem = logOutBtn
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    
    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(ChatListTableViewCell.self, forCellReuseIdentifier: "ChatListTableViewCell")
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
    }
    
}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as? ChatListTableViewCell else { return UITableViewCell() }
        
        let item = chatList[indexPath.row]
        
        cell.setData(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = chatList[indexPath.row]

        FireStoreManager.shared.getChat(item.id, userId: myInfo!.id!) { (message) in
            let vc = ChatViewController()
            vc.setData(item.id, sender: self.myInfo!, msgs: message)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

final class ChatListTableViewCell: UITableViewCell {
    
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
        
        imv.setBorder(radius: 3, width: 1, color: .clear)
        
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
        
        imv.backgroundColor = UIColor.white233
        bottomLine.backgroundColor = UIColor.white233
        dateLb.textColor = UIColor.white(200)
        unreadLb.backgroundColor = .red
        nameLb.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        descLb.font = UIFont.systemFont(ofSize: 12)
        chatLb.font = UIFont.systemFont(ofSize: 13)
        dateLb.font = UIFont.systemFont(ofSize: 11)
        dateLb.textAlignment = .right
        unreadLb.font = UIFont.systemFont(ofSize: 11)
        unreadLb.textColor = .white
        unreadLb.textAlignment = .center
        unreadLb.setBorder(radius: 8, width: 1, color: .clear)
    }
    
    func setData(_ chat: ChatThumbnail) {
        self.dateLb.text = chat.lastDate
        self.unreadLb.text = chat.unreadCount
        self.imv.setImageFrom(chat.senderImg)
        self.nameLb.text = chat.sender
//        self.descLb.text = chat.sender
        self.chatLb.text = chat.lastMsg
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

struct ChatThumbnail: Codable {
    
    let id: String
    let lastDate: String
    let unreadCount: String
    let sender: String
    let senderImg: String
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

struct Chat: Codable {
    let id: String
    let message: [Message]
}

struct Message: Codable {
    let id: String
    let content: String
    let sender: String
    let senderId: String
    let sendDate: Date
    let isMyMessage: Bool
}

