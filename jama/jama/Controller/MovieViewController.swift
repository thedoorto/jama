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
    var movies: [MovieResult] = []
    var wantsToWatch = Set<Int>()
    
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

        let nc = NotificationCenter.default 
        nc.addObserver(forName:Notification.Name(rawValue:"WantsToWatch"),
                       object:nil, queue:nil,
                       using:handleNotification)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMovies()
    }

    func handleNotification(notification:Notification) -> Void {
         guard let userInfo = notification.userInfo,
            let id  = userInfo["id"] as? Int,
            let value = userInfo["value"] as? Bool
            else { return }
        if value {
            wantsToWatch.insert(id)
        } else {
            wantsToWatch.remove(id)
        }
    }
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
        updateMovies()
        sender.endRefreshing()
    }
    
    private func updateMovies() {
        activityIndicator.startAnimating()
        api.getMoviesNowPlaying{ (results) in
            if let results = results {
                self.movies = results
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(integer: 0))
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}

extension MovieViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionCell", for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.row]
        cell.displayMovie(movie: movie, wantsToWatch: wantsToWatch.contains(movie.id))
//        if let posterPath = movie.posterPath, let posterUrl =  api.imageUrlForPath(posterPath) {
//            cell.tag = movie.id
//            cell.displayContent(posterUrl: posterUrl, title: movie.title, wantsToWatch: wantsToWatch.contains(movie.id))
//        }
        return cell
    }
}

extension MovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            detailViewController.movie = movies[indexPath.row]
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
