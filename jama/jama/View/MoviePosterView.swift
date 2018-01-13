//
//  MoviePosterView.swift
//  jama
//
//  Created by Mark Brightman on 11/01/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

import UIKit

class MoviePosterView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: ViewModel = ViewModel() {
        didSet {
            updateImageViewFromUrl(imageView: self.imageView, imageUrl: imageUrlForPath(viewModel.posterPath, width: imageView.frame.width)) { }
            titleLabel.text = viewModel.title
        }
    }
}

extension MoviePosterView {
    struct ViewModel {
        let title: String
        let posterPath: String
//        func posterUrl(size: imageSize = .small) -> String? {
//            return "\(APIBase.baseImageUrl)\(size.rawValue)\(posterPath)"
//        }
    }
}

extension MoviePosterView.ViewModel {

    init(movie: MovieResult) {
        guard let movieTitle = movie.title,
            let path = movie.posterPath else {
                title = ""
                posterPath = ""
                return
        }
        title = movieTitle
        posterPath = path
     }
    
    init() {
        title = ""
        posterPath = ""
     }
}
