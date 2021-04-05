//
//  BreedFetchViewModel.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import Foundation

class BreedFetchViewModel {
    
    //Dependency Injection
    private let apiManager = APIManager()

    func fetchAllBreeds(completionHandler: @escaping ([BreedImage], Error?) -> Void) {
        var allBreedImage: [BreedImage] = []
        let dispatchGroup = DispatchGroup()
        apiManager.requestBreedsList { (breeds, error) in
            let uniqueArray = Set(breeds.map { $0 })    // Set will remove redundancy in array
            if uniqueArray.count > 0 && error == nil {
                uniqueArray.forEach { (breed) in
                    dispatchGroup.enter()
                    self.apiManager.requestRandomImage(breed: breed) { (image, error) in
                        if let breedModel = image, error == nil {
                            let breedImage = BreedImage(image: breedModel.message, breed: breed)
                            allBreedImage.append(breedImage)
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }
        sleep(2)
        dispatchGroup.notify(queue: .main) {
            completionHandler(allBreedImage, nil)
        }
        dispatchGroup.wait()
    }
    
    func fetchRandomImageForBreed(breed: String, completionHandler: @escaping (BreedImage, Error?) -> Void) {
        apiManager.requestRandomImage(breed: breed) { (image, error) in
            if let breedModel = image, error == nil {
                let breedImage = BreedImage(image: breedModel.message, breed: breed)
                completionHandler(breedImage, nil)
            }
        }
    }
}

