//
//  MovieDetailViewController.swift
//  jama
//
//  Created by Mark Brightman on 06/01/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

// TODO: extract view specific code
// TODO: avoid duplication of collection view logic

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    let api: APIClient = APIClient(api: APIBase())
    var movie: MovieResult?
    var movieCollection: MovieCollection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageActivityIndicator.stopAnimating()
        self.collectionActivityIndicator.stopAnimating()
        updateUI()
    }

    func updateUI() {
        guard let movie = movie else {
            return
        }
        titleLabel.text = movie.title
        descriptionText.text = movie.overview
        api.getDetailForMovie(movie) { [weak self] (detail, collection) in
            if let detail = detail {
                self?.updatePosterFromPath(detail.posterPath)
            }
            
            if let collection = collection {
                DispatchQueue.main.async {
                    self?.collectionActivityIndicator.startAnimating()
                }
                self?.movieCollection = collection
                DispatchQueue.main.async {
                    self?.collectionView.reloadSections(IndexSet(integer: 0))
                    self?.collectionActivityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func updatePosterFromPath(_ path: String?) {
        DispatchQueue.main.async {
            self.imageActivityIndicator.startAnimating()
        }
        guard let path = path,
            let imageUrl = api.imageUrlForPath(path, size: .medium) else {
            return
        }
        updateImageViewFromUrl(imageView: self.imageView, imageUrl: imageUrl) {
            self.imageActivityIndicator.stopAnimating()
        }
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movies = movieCollection?.parts else {
            return 0
        }
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieDetailCollectionCell", for: indexPath) as! MovieCollectionViewCell
        guard let movies = movieCollection?.parts else {
            return cell
        }
        let movie = movies[indexPath.row]
        if let posterPath = movie.posterPath, let posterUrl =  api.imageUrlForPath(posterPath) {
            cell.displayContent(posterUrl: posterUrl, title: movie.title)
        }
        return cell
    }
}

extension MovieDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movies = movieCollection?.parts else {
            return
        }
        let movie = movies[indexPath.row]
        titleLabel.text = movie.title
        descriptionText.text = movie.overview
        descriptionText.scrollRangeToVisible(NSMakeRange(0, 0))
        updatePosterFromPath(movie.posterPath)
    }
}

