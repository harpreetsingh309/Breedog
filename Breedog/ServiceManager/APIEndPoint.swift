//
//  APIEndPoint.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import Foundation
    
enum APIEndPoint {
    case randomImageForBreed(String)
    case listAllBreeds
    
    var url: URL {
        return URL(string: self.stringValue)!
    }
    
    var stringValue: String {
        switch self {
        case .randomImageForBreed(let breed):
            return "https://dog.ceo/api/breed/\(breed)/images/random"
        case .listAllBreeds:
            return "https://dog.ceo/api/breeds/list/all"
        }
    }
}
