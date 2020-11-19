//
//  String+.swift
//  WaveApp_Matsota_test
//
//  Created by Andrew Matsota on 19.11.2020.
//

import Foundation

extension String {
    
    func toArray(separated symbols: String) -> [String] {
        var array = [String]()
        for i in self.lowercased()
            .components(separatedBy: CharacterSet(charactersIn: symbols))
            .filter({x in x != ""}) {
                array.append(i)
        }
        return array
    }
    
}
