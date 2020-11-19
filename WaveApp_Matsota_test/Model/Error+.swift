//
//  Error+.swift
//  WaveApp_Matsota_test
//
//  Created by Andrew Matsota on 19.11.2020.
//

import Foundation

enum LocalErrors: Swift.Error {
    
    case launchNotFound
    case rocketNotFound
    
    case unknown
    case connectionLost
    
    var localizedDescription: String {
        switch self {
        case .launchNotFound:
            debugPrint(comment)
            return NSLocalizedString("Missing launch you looking for", comment: comment)
            
        case .rocketNotFound:
            debugPrint(comment)
            return NSLocalizedString("Missing rocket you looking for", comment: comment)
            
        case .unknown:
            debugPrint(comment)
            return NSLocalizedString("Невідома помилка", comment: comment)

        case .connectionLost:
            debugPrint(comment)
            return NSLocalizedString("Немає зв'язку із сервером", comment: comment)
        }
    }
    
    private var comment: String {
        switch self {
        default: return "CUSTOM ERROR: LocalErrors: \(self)"
        }
    }
    
}
