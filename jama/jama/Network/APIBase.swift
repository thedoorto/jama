//
//  APIBase.swift
//  jama
//
//  Created by Mark Brightman on 06/01/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

// TODO: extract image urls and sizes from API call to /configuration

import Foundation

enum ResultType<T> {
    case Success(T)
    case Failure(Error)
}

enum APIError: Error, LocalizedError {
    case unknownError
    case urlError
    
    public var errorDescription: String? {
        switch self {
        case .unknownError:
            return NSLocalizedString("Unknown Error", comment: "")
        case .urlError:
            return NSLocalizedString("URL Error", comment: "")
        }
    }
}

enum imageSize: String {
    case small  = "w154"
    case medium = "w342"
    case large  = "w500"
}

enum apiPath: String {
    case movie      = "/3/movie"
    case nowPlaying = "/3/movie/now_playing"
    case collection = "/3/collection"
}

class APIBase {
    
    // TODO: inject api key amd general config
    let apiKey = "5ceb13584d7786944cf796675575da97"
    let baseImageUrl = "https://image.tmdb.org/t/p/"
    var urlComponents = URLComponents()
    
    init() {
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
    }
    
    func createURLForPath(_ path: apiPath, id: Int? = nil) -> URL? {
        if let id = id {
            urlComponents.path = "\(path.rawValue)/\(id)"
        } else {
            urlComponents.path = path.rawValue
        }
        let apiKeyQuery = URLQueryItem(name: "api_key", value: apiKey)
        urlComponents.queryItems = [apiKeyQuery]
        
        return urlComponents.url
    }
    
    func requestFromUrl<T: Decodable>(_ url: URL, completion: @escaping (ResultType<T>) -> Void) {
        let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            guard error == nil else {
                completion(ResultType.Failure(error!))
                return
            }
            
            guard let data = data else {
                completion(ResultType.Failure(error!))
                return
            }
            
            // TODO: refine error handling to catch specific decoding issues
            do {
                let jsonFromData =  try JSONDecoder().decode(T.self, from: data)
                completion(ResultType.Success(jsonFromData))
            } catch {
                completion(ResultType.Failure(APIError.unknownError))
            }
            
        }).resume()
    }
}
