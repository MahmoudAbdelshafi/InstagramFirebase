//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/16/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit

var imageCache = [String:UIImage]()
class CustomImageView: UIImageView {
    func loadImage(urlString:String){
        self.image = nil
        if let cachedImage = imageCache[urlString]{
            self.image = cachedImage
            print(imageCache)
            return
        }
        var lastURLUsedToLoadImage : String?
        lastURLUsedToLoadImage = urlString
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            if url.absoluteString != lastURLUsedToLoadImage {
                return
            }
            guard let dataImage = UIImage(data: data!) else {return}
            imageCache[url.absoluteString] = dataImage
            DispatchQueue.main.async {
                
                self.image = dataImage
            }
        }.resume()
    }
}

