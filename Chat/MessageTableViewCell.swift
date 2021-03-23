//
//  MessageTableViewCell.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/23.
//

import Foundation
import UIKit

final class MessageTableViewCell: UITableViewCell {
    
    private let tv = UITextView()
    private let dateLb = UILabel()
    
    private let cellWidth = UIWindow().frame.size.width * 0.45
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setAttributes()
    }
    
    private func setUI() {
        
        self.contentView.addSubviews([tv, dateLb])
                
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

    }
    
    func setAttributes() {
        
        self.selectionStyle = .none
        tv.isEditable = false
        tv.isSelectable = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .white233
        tv.setBorder(radius: 3, width: 1, color: .clear)
        dateLb.font = UIFont.systemFont(ofSize: 11)
        
    }
    
    func setMessage(_ message: Message) {
        
        tv.text = message.content
        dateLb.text = "\(message.sendDate)"
        
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

