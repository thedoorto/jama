//
//  MovieCollectionViewCell.swift
//  jama
//
//  Created by Mark Brightman on 06/01/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var watchSwitch: UISwitch!
    @IBOutlet weak var posterView: MoviePosterView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func displayContent(posterUrl: String, title: String?, wantsToWatch: Bool = false) {
        updateImageViewFromUrl(imageView: posterView.imageView, imageUrl: posterUrl) { }
        posterView.titleLabel.text = title
        watchSwitch.setOn(wantsToWatch, animated: false)
    }
    func displayMovie(movie: MovieResult, wantsToWatch: Bool = false) {
        self.tag = movie.id
        posterView.viewModel = MoviePosterView.ViewModel(movie: movie)
        watchSwitch.setOn(wantsToWatch, animated: false)
    }
    func displayMovieCollectionPart(movie: CollectionPart, wantsToWatch: Bool = false) {
        guard let jsonData = movie.jsonData,
            let movieResult = MovieResult.init(data: jsonData) else {
                return
        }
        displayMovie(movie: movieResult)
    }
    @IBAction func watchChanged(_ sender: UISwitch) {
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"WantsToWatch"),
                object: nil,
                userInfo: ["id":self.tag, "value":sender.isOn])
    }
}
