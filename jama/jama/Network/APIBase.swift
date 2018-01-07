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

extension DecodingError {
    
    public var errorDescription: String? {
        switch  self {
        case .dataCorrupted(let context):
            return NSLocalizedString(context.debugDescription, comment: "")
        case .keyNotFound(_, let context):
            return NSLocalizedString("\(context.debugDescription)", comment: "")
        case .typeMismatch(_, let context):
            return NSLocalizedString("\(context.debugDescription)", comment: "")
        case .valueNotFound(_, let context):
            return NSLocalizedString("\(context.debugDescription)", comment: "")
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
    
    // TODO: inject api key and general config
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String
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
            } catch DecodingError.dataCorrupted(let context) {
                completion(ResultType.Failure(DecodingError.dataCorrupted(context)))
            } catch DecodingError.keyNotFound(let key, let context) {
                completion(ResultType.Failure(DecodingError.keyNotFound(key, context)))
            } catch DecodingError.typeMismatch(let type, let context) {
                completion(ResultType.Failure(DecodingError.typeMismatch(type, context)))
            } catch DecodingError.valueNotFound(let value, let context) {
                completion(ResultType.Failure(DecodingError.valueNotFound(value, context)))
            } catch {
                completion(ResultType.Failure(APIError.unknownError))
            }
            
        }).resume()
    }
}
