//
//  BreedsListResponse.swift
//  Breedog
//
//  Created by macexpert on 03/04/21.
//

import Foundation

struct BreedsListResponse: Codable {
    let message: [String: [String]]
    let status: String
}

struct DogImage: Codable {
    let status: String
    let message: String
}

struct BreedImage {
    let image: String
    var breed: String
}
