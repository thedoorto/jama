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
    
    let api: APIClient = APIClient(api: APIBase())
    var movies: [MovieResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api.getMoviesNowPlaying{ (results) in
            if let results = results {
                self.movies = results
                _ = self.movies.map{ print($0.title) }
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(integer: 0))
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
        cell.displayContent(title: movie.title)
        return cell
    }
}

extension MovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
