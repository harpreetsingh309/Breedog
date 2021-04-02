//
//  AbstractCollectionCell.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import UIKit

// MARK: Custom delegate for select/unselect cell
protocol CollectionCellDelegate: class {
    func updateCell()
    func updateModel(_ model: AnyObject, cell: AbstractCollectionCell)
}

class AbstractCollectionCell: UICollectionViewCell, ListControlDelegate {
    
    // MARK: - IBOutlets and Variables
    @IBOutlet var listContainer: UIView!
    
    weak var delegate: CollectionCellDelegate!
    
    class var reuseId: String {
        return String(describing: self)
    }
    
    class var layoutClass: AbstractFlowLayout.Type {
        return AbstractFlowLayout.self
    }
    
    class func flowLayout(_ margin: CGFloat) -> AbstractFlowLayout {
        let layout = self.layoutClass.init(margin)
        return layout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        perform(#selector(self.initViews), with: self, afterDelay: 0.01)
    }
    
    @objc func initViews() {
        initListControl()
    }
    
    internal func viewAppear() {
    }
    
    internal func updateIndex(_ index: IndexPath) {
    }
    
    internal func updateWithModel(_ model: AnyObject) {
    }
    
    internal func updateModel(_ model: AnyObject) {
        delegate.updateModel(model, cell: self)
    }
    
    internal func updateCellSize(_ size: CGFloat) {
    }
    
    @objc func initListControl() {
        if listContainer != nil {
            if collectionController != nil {
                listContainer.addSubview(collectionController.view)
                collectionController.view.addConstraintToFillSuperview()
            }
        } else {
            if collectionController != nil {
                listContainer = UIView()
                addSubview(listContainer)
                addVisualConstraints(["H:|[list]|", "V:|[list]|"], subviews: ["list": listContainer])
                initListControl()
            }
        }
    }
    
    // MARK: - Can be override in child controls.
    var collectionClass: AbstractCollectionListController.Type! {
        return nil
    }
    
    // MARK: - Setter getter methods
    public var _collectionController: AbstractCollectionListController!
    var collectionController: AbstractCollectionListController! {
        if collectionClass == nil {
            return nil
        }
        if _collectionController == nil {
            _collectionController = collectionClass.init(collectionViewLayout: UICollectionViewLayout())
            _collectionController.customDelegate = self
            _collectionController.mainControl = UIApplication.visibleViewController as? AbstractController
        }
        return _collectionController
    }
    
    func updateListModel(_ model: AnyObject?) {
    }
}
