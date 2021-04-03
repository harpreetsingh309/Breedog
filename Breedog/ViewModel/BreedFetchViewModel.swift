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
    
    init() {
        APIManager.requestBreedsList { (arr, err) in
            self.breeds = arr
            print("got array")
        }
    }
    
    func fetchAllBreeds(completionHandler: @escaping ([BreedImage], Error?) -> Void) {
        sleep(2)
        let dispatchGroup = DispatchGroup()
//        APIManager.requestBreedsList { (arr, err) in
//            self.breeds = arr
            self.breeds.forEach { (breed) in
                print("started")
                dispatchGroup.enter()
                APIManager.requestRandomImage(breed: breed) { (image, err) in
                    print("image")
                    let img = BreedImage(image: image!.message, breed: breed)
                    self.allBreedImage.append(img)
                    dispatchGroup.leave()
                }
            }
//        }
        
        dispatchGroup.notify(queue: .main) {
            print("end")
            completionHandler(self.allBreedImage, nil)
            
        }
        dispatchGroup.wait()
    }
    
    func fetchRandomImageForBreed(breed: String) -> [BreedImage] {
        APIManager.requestRandomImage(breed: breed) { (image, err) in
            print("image")
            let img = BreedImage(image: image!.message, breed: breed)
            self.allBreedImage.append(img)
            return self.allBreedImage
        }
        return []
    }
    
//    func fetchBreeds() {
//        apiManager.getDataFromServer(endPoint.stringValue) { (model: DogImage ) in
//            if model.status == "success" {
//
//            }
//        }
//    }
}

