//
//  DogBreedListCVCell.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import UIKit

class DogBreedListCVCell: AbstractCollectionCell {
    
    /// Get layout for collection cell
    override class var layoutClass: AbstractFlowLayout.Type {
        return DogBreedCellLayout.self
    }
    
}
