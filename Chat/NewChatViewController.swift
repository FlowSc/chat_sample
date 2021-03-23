//
//  NewChatViewController.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/20.
//

import UIKit

class NewChatViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let searchView = SearchHeaderView()
    
    var connectedUsers: [User] = []
    
    var myId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()

        searchView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewChatTableViewCell.self, forCellReuseIdentifier: "NewChatTableViewCell")
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        
    }
    
    func setData(_ myId: String) {
        
    }
    
    private func setUI() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension NewChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewChatTableViewCell", for: indexPath) as! NewChatTableViewCell
        
        let item = connectedUsers[indexPath.row]
        
        cell.setData(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = connectedUsers[indexPath.item]
                
        FireStoreManager.shared.makeChat(myId, receiverId: item.id!) { str in
            print(str, "ID")
        }
    }
}

extension NewChatViewController: SearchHeaderViewDelegate {
    func findKeywordChanged(_ text: String) {
        FireStoreManager.shared.findUser(text, myId: myId) { (res) in
            self.connectedUsers = res
            self.tableView.reloadData()
        }
    }
}

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
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.bottomLine.backgroundColor = .white233
            self.titleLb.textColor = .white233
            self.titleLb.font = UIFont.systemFont(ofSize: 13)
            self.layoutIfNeeded()
        }
        
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.bottomLine.backgroundColor = .blue
            self.titleLb.textColor = .blue
            self.titleLb.font = UIFont.systemFont(ofSize: 11)
            self.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.bottomLine.backgroundColor = .white233
            self.titleLb.textColor = .white233
            self.titleLb.font = UIFont.systemFont(ofSize: 13)
            self.layoutIfNeeded()
        }
    }
}

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

class DebounceTextField: UITextField {

    deinit {
        self.removeTarget(self, action: #selector(self.editingChanged), for: .editingChanged)
    }

    private var workItem: DispatchWorkItem?
    private var delay: Double = 0
    private var callback: ((String?) -> Void)? = nil

    func debounce(delay: Double, callback: @escaping ((String?) -> Void)) {
        self.delay = delay
        self.callback = callback
        DispatchQueue.main.async {
            self.callback?(self.text)
        }
        self.addTarget(self, action: #selector(self.editingChanged), for: .editingChanged)
    }

    @objc private func editingChanged(_ sender: UITextField) {
      self.workItem?.cancel()
      let workItem = DispatchWorkItem(block: { [weak self] in
          self?.callback?(sender.text)
      })
      self.workItem = workItem
      DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: workItem)
    }
}
