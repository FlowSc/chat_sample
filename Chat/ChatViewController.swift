//
//  ChatViewController.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/20.
//

import UIKit

class ChatViewController: UIViewController {
    
    private let tableView = UITableView()
    private let sendMessageView = SendMessageView()
    
    private(set) var messages: [Message] = []
    private(set) var chatId: String?
    private(set) var sender: User?
    
    private var isKeyboardOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTableView()
        setKeyboardNotifications()
        addChattigObserver()
      
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        sendMessageView.delegate = self
    }
    
    func setKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func addChattigObserver() {
        FireStoreManager.shared.observeChat(self.chatId!, userId: sender!.id!) { (msgs) in
                        
            self.messages += msgs.sorted(by: { (a, b) -> Bool in
                a.sendDate.timeIntervalSince1970 < b.sendDate.timeIntervalSince1970
            })
            self.tableView.reloadData()
            if self.messages.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: false)
            }
        }
    }
    
    func setData(_ id: String, sender: User) {
        self.chatId = id
        self.sender = sender
        self.tableView.reloadData()
        
    }
    
    private func setUI() {
        
        self.view.addSubviews([tableView, sendMessageView])
        
        sendMessageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
            make.height.lessThanOrEqualTo(100)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(sendMessageView.snp.top)
        }
        
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
                
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if !isKeyboardOn {
                self.view.frame.origin.y -= keyboardSize.height
                isKeyboardOn = true
            }
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if isKeyboardOn {
                self.view.frame.origin.y += keyboardSize.height
                isKeyboardOn = false
            }
        }
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        
        cell.setMessage(messages[indexPath.row])
        
        return cell
        
    }
}

extension ChatViewController: SendMessageViewDelegate {
    
    func focusTextView(_ sender: UITextView) {
        
    }
    
    func sendMessage(_ message: String) {
        guard let sender = sender else { return }
        if message == "" { return }
        FireStoreManager.shared.sendMessage(chatId!, sender: sender, message: message) { (msg) in
            self.sendMessageView.textView.resignFirstResponder()
            self.sendMessageView.textView.text = ""
        }
    }
}
