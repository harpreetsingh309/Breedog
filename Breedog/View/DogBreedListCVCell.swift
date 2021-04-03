//
//  DogBreedListCVCell.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import UIKit
import SDWebImage

class DogBreedListCVCell: AbstractCollectionCell {
    
    @IBOutlet weak var breedTitle: UILabel!
    @IBOutlet weak var breedImage: UIImageView!

    /// Get layout for collection cell
    override class var layoutClass: AbstractFlowLayout.Type {
        return DogBreedCellLayout.self
    }
    
    override func updateWithModel(_ model: AnyObject) {
        if let newModel = model as? BreedImage {
            breedTitle.text = newModel.breed.uppercased()
            if let url = URL(string: newModel.image) {
                print("image >> ",newModel.image)
//                breedImage.loadImage(fromURL: url, placeholderImage: "logo")
                breedImage.sd_setImage(with: url, placeholderImage: UIImage(named: "logo"))

            }
        }
    }
}
