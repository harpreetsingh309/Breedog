//
//  BreedFetchViewModel.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import Foundation

class BreedFetchViewModel {
    
//    private let apiManager: APIManager
//    private let endPoint: APIEndPoint
    var breeds: [String] = []
    var allBreedImage: [BreedImage] = []
//    init(apiManager: APIManager, endPoint: APIEndPoint) {
//        self.apiManager = apiManager
//        self.endPoint = endPoint
//    }
    
//    init() {
//        APIManager.requestBreedsList { (arr, err) in
//            self.breeds = arr
//            print("got array")
//        }
//    }
    
    func fetchAllBreeds(completionHandler: @escaping ([BreedImage], Error?) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        APIManager.requestBreedsList { (breeds, error) in
            if error == nil {
                self.breeds = breeds
                self.breeds.forEach { (breed) in
                    print("started")
                    dispatchGroup.enter()
                    APIManager.requestRandomImage(breed: breed) { (image, error) in
                        if let breedModel = image, error == nil {
                            let breedImage = BreedImage(image: breedModel.message, breed: breed)
                            self.allBreedImage.append(breedImage)
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }
        sleep(2)
        dispatchGroup.notify(queue: .main) {
            print("end")
            completionHandler(self.allBreedImage, nil)
        }
        dispatchGroup.wait()
    }
    
    func fetchRandomImageForBreed(breed: String, completionHandler: @escaping (BreedImage, Error?) -> Void) {
        APIManager.requestRandomImage(breed: breed) { (image, error) in
            if let breedModel = image, error == nil {
                let breedImage = BreedImage(image: breedModel.message, breed: breed)
                completionHandler(breedImage, nil)
            }
        }
    }
}

