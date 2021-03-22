//
//  SignInViewController.swift
//  Rocket_Chat
//
//  Created by Kang Seongchan on 2021/03/19.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
        
    private let idTextField = UITextField()
    private let pwTextField = UITextField()
    private let signInBtn = UIButton()
    private let signUpBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegates()
        setAttributes()
 
    }
    
    private func setUI() {
        
        let views = [idTextField, pwTextField, signInBtn, signUpBtn]
        
        self.view.backgroundColor = .white
        
        views.forEach { $0.setBorder(radius: 3, width: 1, color: .blue) }
        
        view.addSubviews(views)
        
        idTextField.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.leading.equalTo(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        pwTextField.snp.makeConstraints { (make) in
            make.top.equalTo(idTextField.snp.bottom).offset(10)
            make.leading.equalTo(idTextField.snp.leading)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        signInBtn.snp.makeConstraints { (make) in
            make.top.equalTo(pwTextField.snp.bottom).offset(20)
            make.leading.equalTo(idTextField.snp.leading)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        signUpBtn.snp.makeConstraints { (make) in
            make.top.equalTo(signInBtn.snp.bottom).offset(10)
            make.leading.equalTo(idTextField.snp.leading)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            
        }
        
        idTextField.placeholder = "아이디"
        pwTextField.placeholder = "비밀번호"
        idTextField.autocorrectionType = .no
        idTextField.autocapitalizationType = .none
        
        signInBtn.setTitle("로그인", for: .normal)
        signUpBtn.setTitle("회원가입", for: .normal)
        
        
        signInBtn.addTarget(self, action: #selector(requestSignIn), for: .touchUpInside)
        signUpBtn.addTarget(self, action: #selector(moveToSignUp), for: .touchUpInside)
        
    }
    
    @objc func moveToSignUp(_ sender: UIButton) {
        
        let vc = SignUpViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    private func setAttributes() {
        pwTextField.isSecureTextEntry = true
    }
    
    private func setDelegates() {
        idTextField.delegate = self
        pwTextField.delegate = self
    }
    
    @objc func requestSignIn(_ sender: UIButton) {
        
        guard let id = idTextField.text, let pw = pwTextField.text else { return }
        
        FireStoreManager.shared.requestSignIn(id, pw: pw) { (result) in

            if let result = result {
                let chatListVc = ChatListViewController()
                chatListVc.setUser(result)
                let nVc = UINavigationController(rootViewController: chatListVc)
                nVc.modalPresentationStyle = .fullScreen
                self.present(nVc, animated: true)
            } else {
                print("NO RESULT")
            }
        }
    }

}

extension SignInViewController: UITextFieldDelegate {
    
}

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
    
    func setBorder(radius: CGFloat, width: CGFloat = 1, color: UIColor = UIColor.black) {
        
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
        
    }
}

extension UIColor {
    
    static func white(_ point: CGFloat) -> UIColor {
        return UIColor(white: point / 255, alpha: 1)
    }
    
    static var white233: UIColor {
        return UIColor(white: 233/255, alpha: 1)
    }
    
}
