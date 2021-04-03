//
//  APIManager.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import UIKit

class APIManager {
    
    var allBreedsArray: [String]?
    
    func getDataFromServer<T:Decodable>(_ urlString: String, completion: @escaping (T) -> ()) {
        if let url = URL(string: urlString) {
//            showActivityIndicator()
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {[weak self] (data, response, error) in
                if error != nil {
//                    self?.hideActivityIndicator()
//                    self?.showErrorAlert()
                    return
                }
                if let safeData = data {
//                    self?.hideActivityIndicator()
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(T.self, from: safeData)
                        if let dict = try JSONSerialization.jsonObject(with: safeData) as? [String:Any] {
                            self?.allBreedsArray = dict.keys.sorted()
                            print(self?.allBreedsArray)
                        }
                        completion(decodedData)
                    } catch {
//                        self?.showErrorAlert()
                    }
                }
            }
            task.resume()
        } else {
//            showErrorAlert()
        }
    }
    
     class func requestBreedsList(completionHandler: @escaping ([String], Error?) -> Void) {
         let task = URLSession.shared.dataTask(with: APIEndPoint.listAllBreeds.url) { (data, response, error) in
             guard let data = data else {
                 completionHandler([], error)
                 return
             }
             let decoder = JSONDecoder()
             let breedsResponse = try! decoder.decode(BreedsListResponse.self, from: data)
             let breeds = breedsResponse.message.keys.map({$0})
             completionHandler(breeds, nil)
             
         }
         task.resume()
     }
     
     class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
         let randomImageEndpoint = APIEndPoint.randomImageForBreed(breed).url
         let task = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, response, error) in
             guard let data = data else {
                 completionHandler(nil, error)
                 return
             }
             
             let decoder = JSONDecoder()
             let imageData = try! decoder.decode(DogImage.self, from: data)
//             print(imageData)
             completionHandler(imageData, nil)
         }
         task.resume()
     }
     
     class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
         let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
             guard let data = data else {
                 completionHandler(nil, error)
                 return
             }
             let downloadedImage = UIImage(data: data)
             completionHandler(downloadedImage, nil)
         })
         task.resume()
     }
}
