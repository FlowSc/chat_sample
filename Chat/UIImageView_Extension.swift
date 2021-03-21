//
//  UIImageView_Extension.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/20.
//

import Foundation
import UIKit

class ImageCacheManager {
    
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}

extension UIImageView {
    
    func setImageFrom(_ url: String) {
        
            let cacheKey = NSString(string: url)
            if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
                self.image = cachedImage
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                if let imageUrl = URL(string: url) {
                    URLSession.shared.dataTask(with: imageUrl) { (data, res, err) in
                        if let _ = err {
                            DispatchQueue.main.async {
                                self.image = UIImage()
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            if let data = data, let image = UIImage(data: data) {
                                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                                self.image = image
                            }
                        }
                    }.resume()
                }
            }
        }
}


