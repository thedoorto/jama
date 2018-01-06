//
//  MovieDetailViewController.swift
//  jama
//
//  Created by Mark Brightman on 06/01/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    let api: APIClient = APIClient(api: APIBase())
    var movie: MovieResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    func updateUI() {
        guard let movie = movie else {
            return
        }
        api.getDetailForMovie(movie) { (detail, collection) in
            if let detail = detail {
                self.updatePosterFromPath(detail.posterPath)
            }
            
            if let collection = collection {
                _ = collection.parts.map{ print($0.title!)}
            }
        }
    }
    
    func updatePosterFromPath(_ path: String?) {
        if let path = path,
            let imageUrl = api.imageUrlForPath(path, size: "w342"),
            let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }
                if let imageData = data {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: imageData)
                    }
                }
            }).resume()
        }
    }
}
