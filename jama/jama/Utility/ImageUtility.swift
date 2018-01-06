//
//  ImageUtility.swift
//  jama
//
//  Created by Mark Brightman on 06/01/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

import UIKit

func updateImageViewFromUrl(imageView: UIImageView?, imageUrl: String?) {
    if let imageView = imageView, let imageUrl = imageUrl,
        let url = URL(string: imageUrl) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let imageData = data {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: imageData)
                }
            }
        }).resume()
    }
}
