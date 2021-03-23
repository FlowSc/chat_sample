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



