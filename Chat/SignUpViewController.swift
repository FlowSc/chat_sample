//
//  SignUpViewController.swift
//  Rocket_Chat
//
//  Created by Kang Seongchan on 2021/03/19.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    let idTf = UITextField()
    let pwTf = UITextField()
    let nickNameTf = UITextField()
    let descTf = UITextField()
    let profileSelectBtn = UIButton()
    let profileImv = UIImageView()
    
    let signUpBtn = UIButton()
    
    var validEmail: String? {
        return idTf.text
    }
    
    var validPassword: String? {
        return pwTf.text
    }
    
    var validNickname: String? {
        return nickNameTf.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

    }
    
    private func setUI() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubviews([idTf, pwTf, nickNameTf, descTf, profileImv, profileSelectBtn, signUpBtn])
        
        profileImv.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
            make.size.equalTo(50)
        }
        
        profileSelectBtn.snp.makeConstraints { (make) in
            make.center.equalTo(profileImv.snp.center)
            make.size.equalTo(profileImv.snp.size)
        }
        
        idTf.snp.makeConstraints { (make) in
            make.top.equalTo(profileSelectBtn.snp.bottom).offset(20)
            make.leading.equalTo(16)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        pwTf.snp.makeConstraints { (make) in
            make.top.equalTo(idTf.snp.bottom).offset(10)
            make.leading.equalTo(idTf.snp.leading)
            make.height.equalTo(40)

            make.centerX.equalToSuperview()
        }

        
        nickNameTf.snp.makeConstraints { (make) in
            make.top.equalTo(pwTf.snp.bottom).offset(10)
            make.leading.equalTo(idTf.snp.leading)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        descTf.snp.makeConstraints { (make) in
            make.top.equalTo(nickNameTf.snp.bottom).offset(10)
            make.leading.equalTo(idTf.snp.leading)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        
        signUpBtn.snp.makeConstraints { (make) in
            make.top.equalTo(descTf.snp.bottom).offset(30)
            make.leading.equalTo(idTf.snp.leading)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        idTf.placeholder = "아이디를 입력해주세요"
        pwTf.placeholder = "비밀번호를 입력해주세요"
        nickNameTf.placeholder = "닉네임을 입력해주세요"
        descTf.placeholder = "정보를 입력해주세요"
        
        pwTf.isSecureTextEntry = true
        signUpBtn.setTitle("회원가입", for: .normal)
        signUpBtn.setTitleColor(.black, for: .normal)
        
        
        [idTf, pwTf, nickNameTf, descTf].forEach { $0.setBorder(radius: 3, width: 1, color: .white233)}
        
        idTf.addTarget(self, action: #selector(checkId(_:)), for: .allEditingEvents)
        idTf.autocorrectionType = .no
        idTf.autocapitalizationType = .none
        
        pwTf.addTarget(self, action: #selector(checkPassword(_:)), for: .allEditingEvents)
        
        nickNameTf.delegate = self
        nickNameTf.autocorrectionType = .no
        nickNameTf.autocapitalizationType = .none
        
        signUpBtn.addTarget(self, action: #selector(requestSignUp), for: .touchUpInside)
        
    }
    
    @objc func requestSignUp(_ sender: UIButton) {
        
        guard let id = validEmail, let pw = validPassword, let nickname = validNickname else { return }
        
       
        
        let newUser = User(email: id, password: pw, imageUrl: "", nickname: nickname, description: descTf.text ?? "", id: "")
        
        FireStoreManager.shared.addUser(user: newUser) { (isSuccess) in
            if isSuccess {
                
                if let user = try? JSONEncoder().encode(newUser) {
                    UserDefaults.standard.set(user, forKey: "loginUser")
                }
                
                let chatListVc = ChatListViewController()
                chatListVc.setUser(newUser)
                let nVc = UINavigationController(rootViewController: chatListVc)
                nVc.modalPresentationStyle = .fullScreen
                self.present(nVc, animated: true) {
                    self.navigationController?.popToRootViewController(animated: false)
                }
            } else {
                print("FAIL")
            }
        }
    }
    
    @objc func checkId(_ sender: UITextField) {
        if let text = sender.text {
            if !text.contains("@") || !(text.contains(".")) {
              print("IS NOT EMAIL")
            }
        }
    }
    
    @objc func checkPassword(_ sender: UITextField) {
        if let text = sender.text {
            if text.count < 8 {
                print("NOT ENOUGH")
            }
        }
    }

}

extension SignUpViewController: UITextFieldDelegate {}
