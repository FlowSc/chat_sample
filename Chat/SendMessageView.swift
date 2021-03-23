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
    func focusTextView(_ sender: UITextView)
}

class SendMessageView: UIView {
    
    let textView = UITextView()
    private let sendBtn = UIButton()
    
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
        
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.sizeToFit()
        
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

extension SendMessageView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.focusTextView(textView)
    }
}

