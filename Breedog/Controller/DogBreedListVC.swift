//
//  DogBreedListVC.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import UIKit

class DogBreedListVC: AbstractCollectionListController {
    
    override var cellClass: AbstractCollectionCell.Type {
        return DogBreedListCVCell.self
    }
    
    //MARK: - Server Data
    /// Get data from server and call when view did load  and show in collection cell
    override func requestItems(_ query: String, page: Int, completion: @escaping (Array<Any>?, NSError?, Bool?) -> Void) {
        collectionView.isPagingEnabled = false
        completion([1,11,1,1,1,1,2,2,2,2,23,2,2,32,2,23,3,],nil,false)
    }
    
}
