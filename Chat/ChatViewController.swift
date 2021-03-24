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
    private(set) var myInfo: User?
    private(set) var senderProfileImg: String?
    
    private var isKeyboardOn: Bool = false
    
    var keyboardHeight: CGFloat?
    
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
        FireStoreManager.shared.observeChat(self.chatId!, userId: myInfo!.id!) { (msgs) in
                        
            self.messages += msgs.sorted(by: { (a, b) -> Bool in
                a.sendDate.timeIntervalSince1970 < b.sendDate.timeIntervalSince1970
            })
            self.tableView.reloadData()
            if self.messages.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: false)
            }
        }
    }
    
    func setData(_ id: String, myInfo: User, senderName: String, senderImg: String) {
        self.chatId = id
        self.myInfo = myInfo
        self.title = senderName
        self.tableView.reloadData()
        
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
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
                
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if !isKeyboardOn {
                            
                keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
                                        
                UIView.animate(withDuration: 0.3) {
                    guard let height = self.keyboardHeight else { return }
                    self.view.center.y -= height
                    self.view.layoutIfNeeded()
                }
       
                isKeyboardOn = true
            }
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        
            if isKeyboardOn {
                
                UIView.animate(withDuration: 0.3) {
                    guard let height = self.keyboardHeight else { return }
                    self.view.center.y += height
                    self.view.layoutIfNeeded()

                }
                isKeyboardOn = false
            }
        
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        
        cell.setMessage(messages[indexPath.row], senderProfileImg: senderProfileImg ?? "")
        
        return cell
        
    }
}

extension ChatViewController: SendMessageViewDelegate {
    
    func focusTextView(_ sender: UITextView) {
        
    }
    
    func sendMessage(_ message: String) {
        guard let sender = myInfo else { return }
        if message == "" { return }
        FireStoreManager.shared.sendMessage(chatId!, sender: sender, message: message) { (msg) in
            self.sendMessageView.textView.text = ""
            self.sendMessageView.textView.resignFirstResponder()
        }
    }
}
