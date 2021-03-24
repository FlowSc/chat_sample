//
//  SendMessageView.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/23.
//

import Foundation
import UIKit

protocol SendMessageViewDelegate: class {
    func sendMessage(_ message: String)
}

final class SendMessageView: UIView {
    
    private let textView = UITextView()
    
    var messageView: UITextView {
        return textView
    }
    
    private let sendBtn = UIButton()
    
    weak var delegate: SendMessageViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
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
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
        
        textView.keyboardType = .default
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.isScrollEnabled = false
        textView.sizeToFit()
        
        sendBtn.backgroundColor = .white233
        sendBtn.setTitle("전송", for: .normal)
        sendBtn.setTitleColor(.link, for: .normal)
        sendBtn.setBorder(radius: 3, width: 0, color: .clear)
        sendBtn.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        
    }
    
    @objc func sendMessage(_ sender: UIButton) {
        delegate?.sendMessage(textView.text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
