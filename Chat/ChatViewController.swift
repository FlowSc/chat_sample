//
//  ChatViewController.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/20.
//

import UIKit

class ChatViewController: UIViewController {
    
    private let tableView = UITableView()
    let sendMessageView = SendMessageView()
    
    var messages: [Message] = []
    
    var chatId: String?
    
    var sender: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        sendMessageView.delegate = self
        
    }
    
    func setData(_ id: String, sender: User, msgs: [Message]) {
        self.chatId = id
        self.sender = sender
        self.messages = msgs.sorted(by: { (a, b) -> Bool in
            a.sendDate.timeIntervalSince1970 < b.sendDate.timeIntervalSince1970
        })
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
  
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        
        cell.setMessage(messages[indexPath.row])
        
        return cell
        
    }
    
}

extension ChatViewController: SendMessageViewDelegate {
    func sendMessage(_ message: String) {
        guard let sender = sender else { return }
        FireStoreManager.shared.sendMessage(chatId!, sender: sender, message: message) { (msg) in
            guard let msg = msg else { return }
            print(msg)
            self.messages.append(msg)
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
}

class MessageTableViewCell: UITableViewCell {
    
    private let tv = UITextView()
    private let dateLb = UILabel()
    
    private let cellWidth = UIWindow().frame.size.width * 0.45
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    private func setUI() {
        
        self.contentView.addSubviews([tv, dateLb])
        
        tv.isEditable = false
        tv.isSelectable = false
        
        
        
        tv.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalTo(10)
            make.width.equalTo(cellWidth)
            make.bottom.equalTo(-10)
        }
        
        dateLb.snp.makeConstraints { (make) in
            make.leading.equalTo(tv.snp.trailing).offset(5)
            make.bottom.equalTo(tv.snp.bottom)
        }
        
        tv.isScrollEnabled = false
        self.selectionStyle = .none
        tv.backgroundColor = .white233
        tv.setBorder(radius: 3, width: 1, color: .clear)
        dateLb.font = UIFont.systemFont(ofSize: 11)
    }
    
    func setMessage(_ message: Message) {
        
        tv.text = message.content
//        dateLb.text = message.send
        
        guard let isMyMessage = message.isMyMessage else { return }
        
        if !isMyMessage {

            tv.snp.remakeConstraints { (make) in
                make.top.equalTo(10)
                make.leading.equalTo(10)
                make.width.equalTo(cellWidth)
                make.bottom.equalTo(-10)
            }
            
            dateLb.snp.remakeConstraints { (make) in
                make.leading.equalTo(tv.snp.trailing).offset(5)
                make.bottom.equalTo(tv.snp.bottom)
            }
            
            
        } else {
            
            tv.snp.remakeConstraints { (make) in
                make.top.equalTo(10)
                make.trailing.equalTo(-10)
                make.width.equalTo(cellWidth)
                make.bottom.equalTo(-10)
            }
            
            dateLb.snp.remakeConstraints { (make) in
                make.trailing.equalTo(tv.snp.leading).offset(-5)
                make.bottom.equalTo(tv.snp.bottom)
            }
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol SendMessageViewDelegate: class {
    func sendMessage(_ message: String)
}

class SendMessageView: UIView {
    
    let textView = UITextView()
    let sendBtn = UIButton()
    
    weak var delegate: SendMessageViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        
        self.addSubviews([textView, sendBtn])
        self.backgroundColor = .white
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.leading.equalTo(10)
            make.trailing.equalTo(sendBtn.snp.leading).offset(-10)
            make.bottom.equalTo(-5)
        }
        
        textView.backgroundColor = .white233
        textView.setBorder(radius: 3, width: 1, color: .clear)
        
        sendBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.bottom.equalTo(-5)
            make.size.equalTo(30)
        }
        
        sendBtn.backgroundColor = .red
        sendBtn.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        
    }
    
    @objc func sendMessage(_ sender: UIButton) {
        delegate?.sendMessage(textView.text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
