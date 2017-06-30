//
//  NetworkService.swift
//  SevenWestMedia
//
//  Created by siavash abbasalipour on 30/6/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


enum APIRequestType: String {
    case post = "POST"
    case get = "GET"
}

struct RequestClient {
    var urlPath: String = ""
    var requestType: APIRequestType
    var params: JSONDictionary?
    
    init(withPath: String, requestType: APIRequestType, params: JSONDictionary? = nil) {
        self.urlPath = withPath
        self.params = params
        self.requestType = requestType
    }
}

///
/// Describes the result of an asynchronous query
///
enum APICallBack {
    case success(JSONDictionary)
    case error(APIError)
}
enum APIError: Error {
    case server
    case badReponse
    case badRequest
}

class NetworkService {
    
    static let shared = NetworkService()
    
    fileprivate init() {}
    
    func makeNetworkCallWith(requestClient: RequestClient) -> Observable<APICallBack> {
        guard let url = URL.init(string: requestClient.urlPath) else {
            return .error(APIError.badRequest)
        }
        var request = URLRequest.init(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = requestClient.requestType.rawValue
        if let params = requestClient.params {
            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        let session = URLSession.shared
        return Observable.create { observer in
            let task = session.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONDictionary {
                        observer.onNext(.success(json))
                    } else {
                        observer.onNext(.error(APIError.badReponse))
                    }
                }
                if let error = error {
                    observer.onError(error)
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
