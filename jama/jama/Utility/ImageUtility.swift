//
//  ImageUtility.swift
//  jama
//
//  Created by Mark Brightman on 06/01/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

import UIKit

func updateImageViewFromUrl(imageView: UIImageView?, imageUrl: String?, completion: @escaping () -> Void) {
    if let imageView = imageView, let imageUrl = imageUrl,
        let url = URL(string: imageUrl) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            if let imageData = data {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: imageData)
                    completion()
                }
            }
            
        }).resume()
    }
}

func imageUrlForPath(_ path: String, width: CGFloat = 0) -> String? {
    if width > 342 {
        return imageUrlForPath(path, size: .large)
    } else if width > 154 {
        return imageUrlForPath(path, size: .medium)
    }
    return imageUrlForPath(path, size: .small)
}

func imageUrlForPath(_ path: String, size: imageSize = .small) -> String? {
    return "\(APIBase.baseImageUrl)\(size.rawValue)\(path)"
}
