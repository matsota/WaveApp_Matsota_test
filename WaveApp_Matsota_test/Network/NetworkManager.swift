//
//  NetworkManager.swift
//  WaveApp_Matsota_test
//
//  Created by Andrew Matsota on 19.11.2020.
//

import Foundation

protocol NetworkManagment {
    
    func readLaunchList(success: @escaping([RocketLaunch]) -> Void,
                        failure: @escaping(String) -> Void)
    
    func readRocket(description id: Int,
                    success: @escaping([RocketLaunch]) -> Void,
                    failure: @escaping(String) -> Void)
    
}









class NetworkManager {
    
    /// - Parameters
    private let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
}









//MARK: - By protocol
extension NetworkManager: NetworkManagment {
    
    func readLaunchList(success: @escaping([RocketLaunch]) -> Void,
                        failure: @escaping(String) -> Void) {
        let parameters: [String: Any] = ["mode": "list", "sort": "desc", "fields": "id,name", "limit": 1000000]
        networking.getRequest(api: API.launch_path, with: parameters) { (data, error) in
            self.decode(received: data, in: "readLaunchList") { (result: RocketLaunchList) in
                success(result.launches)
            } failure: { (localizedDescription) in
                failure(localizedDescription)
            }
        }
    }
    
    func readRocket(description id: Int,
                    success: @escaping([RocketLaunch]) -> Void,
                    failure: @escaping(String) -> Void) {
        
        let parameters: [String: Any] = ["mode": "verbose", "id": "\(id)"]
        networking.getRequest(api: API.launch_path, with: parameters) { (data, error) in
            self.decode(received: data, in: "readLaunchList") { (result: RocketLaunchList) in
                success(result.launches)
            } failure: { (localizedDescription) in
                failure(localizedDescription)
            }
        }
    }
    
}









//MARK: - Private Methods
private extension NetworkManager {
    
    /// - `decode` received data in defined method with further transition of it
    func decode<T>(received data: Data?, in method: String,
                   success: @escaping(T) -> Void,
                   failure: @escaping(String) -> Void) where T: Decodable {
        do {
            guard let data = data else {
                failure(LocalErrors.connectionLost.localizedDescription)
                return
            }
            
            let response = try JSONDecoder().decode(T.self, from: data)
            success(response)
        }catch{
            debugPrint("ERROR: NetworkManager: \(method)", error.localizedDescription)
            failure(LocalErrors.unknown.localizedDescription)
        }
    }
    
}
