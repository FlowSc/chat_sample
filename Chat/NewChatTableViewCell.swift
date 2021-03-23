//
//  NewChatTableViewCell.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/23.
//

import Foundation
import UIKit

final class NewChatTableViewCell: UITableViewCell {
    
    private let imv = UIImageView()
    private let nameLb = UILabel()
    private let descLb = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    private func setUI() {
        
        self.selectionStyle = .none
        
        self.contentView.addSubviews([imv, nameLb, descLb])
        
        imv.snp.makeConstraints { (make) in
            make.top.leading.equalTo(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        
        nameLb.snp.makeConstraints { (make) in
            make.top.equalTo(imv.snp.top)
            make.leading.equalTo(imv.snp.trailing).offset(10)
            make.trailing.equalTo(-10)
        }
        
        descLb.snp.makeConstraints { (make) in
            make.bottom.equalTo(imv.snp.bottom)
            make.leading.equalTo(imv.snp.trailing).offset(10)
            make.trailing.equalTo(-10)
        }
        
        imv.backgroundColor = UIColor.white233
        nameLb.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        descLb.font = UIFont.systemFont(ofSize: 12)
        imv.setBorder(radius: 3, width: 1, color: .clear)
        
    }
    
    func setData(_ user: User) {
        self.imv.setImageFrom(user.imageUrl)
        self.nameLb.text = user.nickname
        self.descLb.text = user.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

