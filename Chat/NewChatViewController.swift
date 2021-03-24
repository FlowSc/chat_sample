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
    
    var myInfo: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setTableView()
  
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchView.textField.resignFirstResponder()
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        searchView.delegate = self
        tableView.register(NewChatTableViewCell.self, forCellReuseIdentifier: "NewChatTableViewCell")
    }
    
    @objc func keyboardDismiss() {
        
        searchView.textField.resignFirstResponder()

    }
    
    func setData(_ info: User?) {
        self.myInfo = info
    }
        
    private func setUI() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.navigationController?.navigationBar.isTranslucent = false
    }
}

extension NewChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchView.textField.resignFirstResponder()
    }
    
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
        
        searchView.textField.resignFirstResponder()
        
        guard let id = self.myInfo?.id, let receiverId = item.id else { return }
                
        FireStoreManager.shared.makeChat(id, receiverId: receiverId) { str in
            let vc = ChatViewController()
            guard let myInfo = self.myInfo else { return }
            vc.setData(str, myInfo: myInfo, senderName: item.nickname, senderImg: item.imageUrl)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

extension NewChatViewController: SearchHeaderViewDelegate {
    func findKeywordChanged(_ text: String) {
        guard let myId = self.myInfo?.id else { return }
        if text == "" { return }
        FireStoreManager.shared.findUser(text, myId: myId) { (res) in
            self.connectedUsers = res
            self.tableView.reloadData()
        }
    }
}



