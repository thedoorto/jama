//
//  APIBase.swift
//  jama
//
//  Created by Mark Brightman on 06/01/2018.
//  Copyright © 2018 Mark Brightman. All rights reserved.
//

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

class APIBase {
    
    let API_KEY = "5ceb13584d7786944cf796675575da97"
    var urlComponents = URLComponents()
    
    init() {
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
    }
    
    func createURLWithPath(_ path: String) -> URL? {
        urlComponents.path = "/3/\(path)"
        let apiKeyQuery = URLQueryItem(name: "api_key", value: API_KEY)
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
            
            do {
                let jsonFromData =  try JSONDecoder().decode(T.self, from: data)
                completion(ResultType.Success(jsonFromData))
            } catch {
                completion(ResultType.Failure(APIError.unknownError))
            }
            
        }).resume()
    }
}
