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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getChatList()
    }
    
    func setUser(_ result: User) {
        self.myInfo = result
    }
    
    func getChatList() {
        guard let myId = myInfo?.id else { return }
        FireStoreManager.shared.getChatList(myId) { (list) in
            self.chatList = []
            list.forEach { (chat) in
                FireStoreManager.shared.getUser(chat.other) { (user) in
                    guard let user = user else { return }
                    let chatThumbnail = ChatThumbnail(id: chat.chatId, lastDate: "", unreadCount: "", sender: user.nickname, senderImg: user.imageUrl, senderDesc: user.description, lastMsg: chat.lastMsg)
                    self.chatList.append(chatThumbnail)
                    if list.count == self.chatList.count {
                        
                        self.tableView.reloadData()
                    }
                }
            }
        }
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
    
    @objc func moveToNewMessage() {
        
        guard let myId = myInfo?.id else { return }
        
        let newChatVc = NewChatViewController()
        
        newChatVc.myId = myId
        
        self.navigationController?.pushViewController(newChatVc, animated: true)
                
    }
    
    @objc func logOut() {
        
        UserDefaults.standard.removeObject(forKey: "loginUser")
        self.dismiss(animated: true, completion: nil)
        
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
        
        let vc = ChatViewController()
        guard let sender = self.myInfo else { return }
        vc.setData(item.id, sender: sender)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}

