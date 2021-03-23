//
//  SearchHeaderView.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/23.
//

import Foundation
import UIKit

protocol SearchHeaderViewDelegate: class {
    func findKeywordChanged(_ text: String)
}

class SearchHeaderView: UIView {
    
    private let titleLb = UILabel()
    private let textField = DebounceTextField()
    private let bottomLine = UIView()
    private let connectedLb = UILabel()
    
    var delegate: SearchHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
        self.addSubviews([titleLb, textField, bottomLine, connectedLb])
        
        titleLb.snp.makeConstraints { (make) in
            make.top.leading.equalTo(15)
            make.height.equalTo(20)
        }
        
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(5)
            make.leading.equalTo(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom)
            make.leading.equalTo(textField.snp.leading)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        connectedLb.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLine.snp.bottom).offset(15)
            make.leading.equalTo(titleLb.snp.leading)
            make.bottom.equalTo(-10)
        }
        
        bottomLine.backgroundColor = .white233
        titleLb.text = "받는 사람"
        titleLb.textColor = .white233
        titleLb.font = UIFont.systemFont(ofSize: 13)
        connectedLb.text = "연결된 사람"
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        textField.debounce(delay: 0.5) { [weak self] (text) in
            guard let self = self, let text = text else { return }
            self.delegate?.findKeywordChanged(text)
        }
        
        
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension SearchHeaderView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.bottomLine.backgroundColor = .blue
            self.titleLb.textColor = .blue
            self.titleLb.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.bottomLine.backgroundColor = .white233
            self.titleLb.textColor = .white233
            self.titleLb.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
}
