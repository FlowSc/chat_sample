//
//  AppDelegate.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/19.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        let rootVc = SignInViewController()
        
        let nVc = UINavigationController(rootViewController: rootVc)
        
        window?.rootViewController = nVc
        
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()        
        
        return true
    }
    
}

