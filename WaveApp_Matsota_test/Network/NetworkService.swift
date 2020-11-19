//
//  NetworkManagment.swift
//  WaveApp_Matsota_test
//
//  Created by Andrew Matsota on 19.11.2020.
//

import Foundation
import Alamofire

protocol Networking {
    
    func getRequest(api method: String,
                    with parameters: [String: Any],
                    completion: @escaping (Data?, Error?) -> Void)
    
}

class NetworkService: Networking {
    
    //MARK: - GET
    func getRequest(api method: String,
                    with parameters: [String: Any],
                    completion: @escaping (Data?, Error?) -> Void) {
        guard let url = self.url(from: method, parameters: parameters) else {return}
        
        print(url)
        AF.request(url, method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: nil,
                   interceptor: nil)
            .responseData { (response) in
                switch response.result {
                case .success(_):
                    completion(response.data, nil)
                    
                case .failure(_):
                    completion(response.data, response.error)
                }
            }
    }
    
}









//MARK: - Private Methods
private extension NetworkService {
    
    func url(from path: String, parameters: [String: Any]) -> URL? {
        var components = URLComponents()
        
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: "\(value)"))
        }
        components.queryItems = queryItems
        return components.url
    }
    
}

