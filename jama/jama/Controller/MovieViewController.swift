//
//  ViewController.swift
//  jama
//
//  Created by Mark Brightman on 06/01/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let api: APIClient = APIClient(api: APIBase())
    var viewModel: ViewModel = ViewModel() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadSections(IndexSet(integer: 0))
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Now Playing", comment: "Now Playing")
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Pull to refresh", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self,
                                 action: #selector(refreshOptions(sender:)),
                                 for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMovies()
    }

    @objc private func refreshOptions(sender: UIRefreshControl) {
        updateMovies()
        sender.endRefreshing()
    }
    
    private func updateMovies() {
        activityIndicator.startAnimating()
        api.getMoviesNowPlaying{ [weak self] (results) in
            if let results = results {
                self?.viewModel = ViewModel(results: results)
            }
        }
    }
}

extension MovieViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalResults
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionCell", for: indexPath) as! MovieCollectionViewCell
        guard let movies = viewModel.movies, indexPath.row < movies.count else {
            return cell
        }
        let movie = movies[indexPath.row]
        if let posterPath = movie.posterPath, let posterUrl =  api.imageUrlForPath(posterPath) {
            cell.displayContent(posterUrl: posterUrl, title: movie.title)
        }
        return cell
    }
}

extension MovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movies = viewModel.movies,
            indexPath.row < movies.count,
            let detailViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
            return
        }
        detailViewController.movie = movies[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension MovieViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        _ = indexPaths.map{print("prefetch:\($0.row)")}
    }
}

extension MovieViewController {
    struct ViewModel {
        let movies: [MovieViewModel]?
        let page: Int
        let totalResults: Int
        let totalPages: Int
    }
    struct MovieViewModel {
        let id: Int
        let title: String?
        let posterPath: String?
//        let genreIDS: [Int]?
        let overview: String?
    }
}

extension MovieViewController.MovieViewModel {
    init(movie: MovieResult) {
        id = movie.id
        title = movie.title
        posterPath = movie.posterPath
        overview = movie.overview
    }
    init() {
        id = 0
        title = nil
        posterPath = nil
        overview = nil
    }
}

extension MovieViewController.ViewModel {
    init(results: MovieResults) {
        page = results.page
        totalResults = results.totalResults
        totalPages = results.totalPages
        movies = results.results.map{
            return MovieViewController.MovieViewModel(movie: $0)
        }
    }
    init() {
        page = 0
        totalResults = 0
        totalPages = 0
        movies = nil
    }
}


