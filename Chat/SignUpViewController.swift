//
//  SignUpViewController.swift
//  Rocket_Chat
//
//  Created by Kang Seongchan on 2021/03/19.
//

import UIKit
import Firebase
import Toast_Swift

class SignUpViewController: UIViewController {
    
    private let idTf = DebounceTextField()
    private let idCheckLb = UILabel()
    private let pwTf = UITextField()
    private let nickNameTf = DebounceTextField()
    private let nickNameCheckLb = UILabel()
    private let descTf = UITextField()
    private let profileSelectBtn = UIButton()
    private let profileImv = UIImageView()
    
    private let signUpBtn = UIButton()
    
    private(set) var isValidEmail: Bool = false
    private(set) var isValidNickName: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        mappingFunctions()

    }
    
    private func setUI() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubviews([idTf, idCheckLb, pwTf, nickNameTf, nickNameCheckLb, descTf, signUpBtn])
        
//        profileImv.snp.makeConstraints { (make) in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
//            make.centerX.equalToSuperview()
//            make.size.equalTo(50)
//        }
//
//        profileSelectBtn.snp.makeConstraints { (make) in
//            make.center.equalTo(profileImv.snp.center)
//            make.size.equalTo(profileImv.snp.size)
//        }
//
        idTf.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(16)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        idCheckLb.snp.makeConstraints { (make) in
            make.top.equalTo(idTf.snp.bottom).offset(10)
            make.leading.equalTo(idTf.snp.leading)
            make.height.equalTo(30)
        }
        
        pwTf.snp.makeConstraints { (make) in
            make.top.equalTo(idCheckLb.snp.bottom).offset(10)
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
        
        nickNameCheckLb.snp.makeConstraints { (make) in
            make.top.equalTo(nickNameTf.snp.bottom).offset(10)
            make.leading.equalTo(idTf.snp.leading)
            make.height.equalTo(30)
        }
        
        descTf.snp.makeConstraints { (make) in
            make.top.equalTo(nickNameCheckLb.snp.bottom).offset(10)
            make.leading.equalTo(idTf.snp.leading)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        signUpBtn.snp.makeConstraints { (make) in
            make.top.equalTo(descTf.snp.bottom).offset(30)
            make.leading.equalTo(idTf.snp.leading).offset(30)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        idTf.placeholder = "이메일을 입력해주세요"
        pwTf.placeholder = "비밀번호를 입력해주세요"
        nickNameTf.placeholder = "닉네임을 입력해주세요"
        descTf.placeholder = "정보를 입력해주세요"
        
        pwTf.isSecureTextEntry = true
        signUpBtn.setTitle("회원가입", for: .normal)
        signUpBtn.setBorder(radius: 3)
        signUpBtn.setTitleColor(.black, for: .normal)
        
        
        [idTf, pwTf, nickNameTf, descTf].forEach { $0.setBorder(radius: 3, width: 1, color: .white233)}
        
        idTf.autocorrectionType = .no
        idTf.autocapitalizationType = .none
        nickNameTf.autocorrectionType = .no
        nickNameTf.autocapitalizationType = .none
        nickNameCheckLb.font = UIFont.systemFont(ofSize: 12)
        idCheckLb.font = UIFont.systemFont(ofSize: 12)
        nickNameCheckLb.textColor = .red
        idCheckLb.textColor = .red
        
        signUpBtn.addTarget(self, action: #selector(requestSignUp), for: .touchUpInside)
        
    }
    
    private func mappingFunctions() {
        
        idTf.debounce(delay: 0.3) { (str) in
            guard let str = str else { return }
            if str == "" { return }
            
            if !str.contains("@") || !str.contains(".") {
                self.idCheckLb.text = "이메일 형식이 잘못되었습니다"
                self.isValidEmail = false
                return
            }
            
            FireStoreManager.shared.checkEmail(str) { (result) in
                self.isValidEmail = result
                self.idCheckLb.textColor = result ? UIColor.link : UIColor.red
                self.idCheckLb.text = result ? "사용 가능한 이메일입니다" : "중복된 이메일입니다"
            }
        }
        
        nickNameTf.debounce(delay: 0.3) { (str) in
            guard let str = str else { return }
            if str == "" { return }
            FireStoreManager.shared.checkNickname(str) { (result) in
                self.isValidNickName = result
                self.nickNameCheckLb.textColor = result ? UIColor.link : UIColor.red
                self.nickNameCheckLb.text = result ? "사용 가능한 닉네임입니다" : "중복된 닉네임입니다"

            }
        }
    }
    
    @objc func requestSignUp(_ sender: UIButton) {
        
        if isValidEmail && isValidNickName {

            guard let id = idTf.text, let pw = pwTf.text, let nickname = nickNameTf.text else { return }
            
            let newUser = User(email: id, password: pw, imageUrl: "https://via.placeholder.com/150", nickname: nickname, description: descTf.text ?? "", id: "")
            
            FireStoreManager.shared.addUser(user: newUser) { (isSuccess) in
                if isSuccess {
                                        
                    FireStoreManager.shared.requestSignIn(id, pw: pw) { (result) in
                        
                        guard let result = result else { return }
                        
                        if let user = try? JSONEncoder().encode(result) {
                            UserDefaults.standard.set(user, forKey: "loginUser")
                        }
                        
                        let chatListVc = ChatListViewController()
                        chatListVc.setUser(result)
                        let nVc = UINavigationController(rootViewController: chatListVc)
                        nVc.modalPresentationStyle = .fullScreen
                        self.present(nVc, animated: true) {
                            self.navigationController?.popToRootViewController(animated: false)
                        }
                    }
                } else {
                    self.view.makeToast("회원가입에 실패하였습니다")
                }
            }
            
        }
        
    }

}

extension SignUpViewController: UITextFieldDelegate {}
