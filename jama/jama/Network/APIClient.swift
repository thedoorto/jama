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
    
    func getNowPlaying(_ completion: @escaping (ResultType<MovieResults>) -> Void) {
        guard let url = apiBase?.createURLWithPath("movie/now_playing") else {
            completion(ResultType.Failure(APIError.urlError))
            return
        }
        apiBase?.requestFromUrl(url, completion: completion)
    }
    
    func getMovieById(_ completion: @escaping () -> Void) {
    }
    
    func getCollectionById(_ completion: @escaping () -> Void) {
    }
}
