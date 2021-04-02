//
//  AbstractFlowLayout.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import UIKit

class AbstractFlowLayout: UICollectionViewFlowLayout {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init-coder has not been implemented")
    }
    
    required init(_ margin: CGFloat) {
        super.init()
        parentMargin = margin
        initView()
    }
    
    var parentMargin: CGFloat = 0.0
    
    func initView() {
        scrollDirection = .vertical
        sectionInset = .zero
        minimumLineSpacing = minLineSpace
        minimumInteritemSpacing = 0
        itemSize = cellSize
    }
    
    var minLineSpace: CGFloat {
        return 0
    }
    
    var aspectRatio: CGFloat {
        return 0.4
    }
    
    var width: CGFloat {
        return UIScreen.main.bounds.width - (parentMargin * 2.0)
    }
    
    var height: CGFloat {
        return width * self.aspectRatio
    }
    
    var rows: CGFloat {
        return 1.0
    }
    
    var cellSize: CGSize {
        return CGSize(width: (width - ((rows-1) * self.minimumLineSpacing))/rows, height: self.height)
    }
}
