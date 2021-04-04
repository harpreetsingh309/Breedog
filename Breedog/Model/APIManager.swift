//
//  APIManager.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import UIKit

class APIManager {

    private var activityView: UIActivityIndicatorView?

    // MARK:- API Calls
    func requestBreedsList(completionHandler: @escaping ([String], Error?) -> Void) {
        showActivityIndicator()
        URLSession.shared.dataTask(with: APIEndPoint.listAllBreeds.url) {[weak self] (data, response, error) in
             guard let data = data else {
                 completionHandler([], error)
                 return
             }
             let decoder = JSONDecoder()
            do {
                let breedsResponse = try decoder.decode(BreedsListResponse.self, from: data)
                let breeds = breedsResponse.message.keys.map({$0})
                completionHandler(breeds, nil)
            } catch {
                self?.showErrorAlert()
            }
            self?.hideActivityIndicator()
         }.resume()
     }
     
    func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let randomImageEndpoint = APIEndPoint.randomImageForBreed(breed).url
        URLSession.shared.dataTask(with: randomImageEndpoint) {[weak self] (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let imageData = try decoder.decode(DogImage.self, from: data)
                completionHandler(imageData, nil)
            } catch {
                self?.showErrorAlert()
            }
        }.resume()
    }
    
    // MARK: Alert
    private func showErrorAlert() {
        DispatchQueue.dispatch_async_main {
            Alert.showAlert(message: ErrorConstants.serverError)
        }
    }

    // MARK:-  Activity Indicator
    private func showActivityIndicator() {
        self.activityView = UIActivityIndicatorView(style: .large)
        self.activityView?.color = .black
        DispatchQueue.dispatch_async_main {
            self.activityView!.center = UIApplication.scene.view.center
            UIApplication.scene.view.addSubview(self.activityView!)
            UIApplication.scene.view.bringSubviewToFront(self.activityView!)
            self.activityView!.startAnimating()
        }
    }
    
    private func hideActivityIndicator(){
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.activityView?.stopAnimating()
            self.activityView?.removeFromSuperview()
            self.activityView = nil
        }
    }
}
