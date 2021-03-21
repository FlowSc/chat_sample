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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        
//        getDummy()
    }
    
    func setData(_ id: String, msgs: [Message]) {
        self.chatId = id
        self.messages = msgs
        self.tableView.reloadData()
    }
    
    func getDummy() {
        
        for i in 0...10 {
            
            let message = Message(id: "1", content: "안녕하ㅔ오머ㅏㄴ옴나ㅓ오머나오머ㅏㄴ와먼와ㅓㅁㄴ와ㅓㅁㄴ오\nashdjkashdkasd\nasdhjkasdhjaskdhjkashdjkashdkasj", date: "2020.1.1", isSended: i % 2 == 0)
            
            self.messages.append(message)
            
        }
        
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
        dateLb.text = message.date
        
        if !message.isSended {

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
    func sendMessage(_ message: Message)
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
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
