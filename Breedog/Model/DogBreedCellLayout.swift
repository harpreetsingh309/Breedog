//
//  DogBreedCellLayout.swift
//  Breedog
//
//  Created by macexpert on 04/04/21.
//

import UIKit

class DogBreedCellLayout: AbstractFlowLayout {
    
    // MARK: - Override variables
    override func initView() {
        super.initView()
        scrollDirection = .vertical
    }
    
    override var aspectRatio: CGFloat {
        return 0.5
    }
    
    override var rows: CGFloat {
        return 2.0
    }
    
    override var minLineSpace: CGFloat {
        return 20
    }
}
