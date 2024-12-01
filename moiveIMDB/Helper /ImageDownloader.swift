//
//  ImageDownloader.swift
//  moiveIMDB
//
//  Created by manukant tyagi on 30/11/24.
//

import Foundation
import UIKit

class ImageDownloader {
    private static let imageCache = NSCache<NSURL, UIImage>()
    
    static func downloadImage(from url: URL, completion: @escaping(UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            completion(cachedImage)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(nil)
            }
            
            guard let data ,let image = UIImage(data:data) else {
                print("invalid data")
                completion(nil)
                return
            }
            
            // cache the image
            imageCache.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
        
    }
}
