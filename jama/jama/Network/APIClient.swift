//
//  APIClient.swift
//  jama
//
//  Created by Mark Brightman on 06/01/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

import Foundation

class APIClient {
    
    var apiBase: APIBase?
    
    init(api: APIBase) {
        self.apiBase = api
    }
    
    func getMoviesNowPlaying(completion: @escaping ([MovieResult]?) -> Void) {
        getNowPlaying{ (results) in
            switch results {
            case .Success(let value):
                completion(value.results)
            case .Failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func imageUrlForPath(_ path: String, size: String = "w185") -> String? {
        let imageUrl = "https://image.tmdb.org/t/p/\(size)\(path)"
        return imageUrl
    }
    
    private func getNowPlaying(completion: @escaping (ResultType<MovieResults>) -> Void) {
        guard let url = apiBase?.createURLWithPath("movie/now_playing") else {
            completion(ResultType.Failure(APIError.urlError))
            return
        }
        apiBase?.requestFromUrl(url, completion: completion)
    }
    
    private func getMovieById(_ completion: @escaping () -> Void) {
    }
    
    private func getCollectionById(_ completion: @escaping () -> Void) {
    }
}
