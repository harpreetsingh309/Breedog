//
//  DogBreedVC.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import UIKit

class DogBreedVC: AbstractController {
    
    override var collectionClass: AbstractCollectionListController.Type! {
        return DogBreedListVC.self
    }
}
