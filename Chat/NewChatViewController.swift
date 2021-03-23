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

        searchView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewChatTableViewCell.self, forCellReuseIdentifier: "NewChatTableViewCell")
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        
    }
    
    func setData(_ info: User?) {
        self.myInfo = info
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
        
        guard let id = self.myInfo?.id, let receiverId = item.id else { return }
                
        FireStoreManager.shared.makeChat(id, receiverId: receiverId) { str in
            print(str, "ID")
            
            let vc = ChatViewController()
            guard let sender = self.myInfo else { return }
            vc.setData(str, sender: sender)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

extension NewChatViewController: SearchHeaderViewDelegate {
    func findKeywordChanged(_ text: String) {
        guard let myId = self.myInfo?.id else { return }
        FireStoreManager.shared.findUser(text, myId: myId) { (res) in
            self.connectedUsers = res
            self.tableView.reloadData()
        }
    }
}



