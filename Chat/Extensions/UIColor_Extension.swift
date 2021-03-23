//
//  UIColor_Extension.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/23.
//

import Foundation
import UIKit
extension UIColor {
    
    static func white(_ point: CGFloat) -> UIColor {
        return UIColor(white: point / 255, alpha: 1)
    }
    
    static var white233: UIColor {
        return UIColor(white: 233/255, alpha: 1)
    }
    
}
