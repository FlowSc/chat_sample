//
//  UIView_Extension.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/23.
//

import Foundation
import UIKit

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
    
    var safeAreaBottom: CGFloat {
          if #available(iOS 11, *) {
            if let window = UIApplication.shared.windows.first {
                 return window.safeAreaInsets.bottom
             }
          }
          return 0
     }

    var safeAreaTop: CGFloat {
          if #available(iOS 11, *) {
            if let window = UIApplication.shared.windows.first {
                 return window.safeAreaInsets.top
             }
          }
          return 0
     }
}

