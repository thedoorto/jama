//
//  MovieCollectionViewCell.swift
//  jama
//
//  Created by Mark Brightman on 06/01/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func displayContent(posterUrl: String, title: String?) {
        updateImageViewFromUrl(imageView: self.imageView, imageUrl: posterUrl)
        titleLabel.text = title
    }
}
