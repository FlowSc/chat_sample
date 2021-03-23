//
//  MessageTableViewCell.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/23.
//

import Foundation
import UIKit

final class MessageTableViewCell: UITableViewCell {
    
    private let profileImv = UIImageView()
    private let tv = UITextView()
    private let dateLb = UILabel()
    
    private let minimumWidth = UIWindow().frame.size.width * 0.3
    private let maximumWidth = UIWindow().frame.size.width * 0.6
    
    private var dateFormatter: DateFormatter {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setAttributes()
    }
    
    private func setUI() {
        
        self.contentView.addSubviews([profileImv, tv, dateLb])
        
        tv.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalTo(10)
            make.width.greaterThanOrEqualTo(minimumWidth)
            make.width.lessThanOrEqualTo(maximumWidth)
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
        tv.isScrollEnabled = false
        tv.autocorrectionType = .no
        tv.autocapitalizationType = .none
        tv.dataDetectorTypes = .all
        tv.backgroundColor = .white233
        tv.setBorder(radius: 3, width: 1, color: .clear)
        profileImv.setBorder(radius: 5, width: 1, color: .clear)
        dateLb.font = UIFont.systemFont(ofSize: 11)
    }
    
    func setMessage(_ message: Message, senderProfileImg: String) {
        
        let date = dateFormatter.string(from: message.sendDate)

        tv.text = message.content
        dateLb.text = date
        profileImv.setImageFrom(senderProfileImg)
        
        guard let isMyMessage = message.isMyMessage else { return }
        
        if !isMyMessage {
            
            profileImv.isHidden = false
            
            profileImv.snp.makeConstraints { (make) in
                
                make.top.equalTo(10)
                make.leading.equalTo(10)
                make.size.equalTo(30)
                
            }
            
            tv.snp.remakeConstraints { (make) in
                make.top.equalTo(10)
                make.leading.equalTo(profileImv.snp.trailing).offset(5)
                make.trailing.lessThanOrEqualTo(-minimumWidth)
                make.bottom.equalTo(-10)
            }
            
            dateLb.snp.remakeConstraints { (make) in
                make.leading.equalTo(tv.snp.trailing).offset(5)
                make.bottom.equalTo(tv.snp.bottom)
            }
            
        } else {
            
            profileImv.isHidden = true
            
            tv.snp.remakeConstraints { (make) in
                make.top.equalTo(10)
                make.trailing.equalTo(-10)
                make.leading.greaterThanOrEqualTo(minimumWidth)
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

