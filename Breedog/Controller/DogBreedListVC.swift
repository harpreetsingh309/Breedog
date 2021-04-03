//
//  DogBreedListVC.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import UIKit

class DogBreedListVC: AbstractCollectionListController {
    
    private let viewModel = BreedFetchViewModel()
    
    override var cellClass: AbstractCollectionCell.Type {
        return DogBreedListCVCell.self
    }
    
    //MARK: - Server Data
    /// Get data from server and call when view did load  and show in collection cell
    override func requestItems(_ query: String, page: Int, completion: @escaping (Array<Any>?, NSError?, Bool?) -> Void) {
        viewModel.fetchAllBreeds { (images, err) in
            if err == nil {
                DispatchQueue.main.async {
                    self.items = images
                    completion(self.items,nil,false)
                }
            }
        }
        completion([],nil,false)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.requestRandomImage
    }

    
    
}
