//
//  MovieDetailView.swift
//  jama
//
//  Created by Mark Brightman on 12/01/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

import UIKit

class MovieDetailView: UIView {

    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var posterView: MoviePosterView!
    
    var viewModel: ViewModel = ViewModel() {
        didSet {
            descriptionText.text = viewModel.description
//            posterView.viewModel = viewModel.poster
        }
    }
}

extension MovieDetailView {
    struct ViewModel {
        let description: String
        let poster: MoviePosterView.ViewModel
    }
}

extension MovieDetailView.ViewModel {
    
    init(movie: MovieDetail) {
        guard let movieDescription = movie.overview,
            let jsonData = movie.jsonData,
            let movieResult = MovieResult.init(data: jsonData)
            else {
                description = ""
                poster = MoviePosterView.ViewModel()
                return
        }
        description = movieDescription
        poster = MoviePosterView.ViewModel(movie: movieResult)
    }
    init(result: MovieResult) {
        guard let movieDescription = result.overview
            else {
                description = ""
                poster = MoviePosterView.ViewModel()
                return
        }
        description = movieDescription
        poster = MoviePosterView.ViewModel(movie: result)
    }
    
    init() {
        description = ""
        poster = MoviePosterView.ViewModel()
    }
}
