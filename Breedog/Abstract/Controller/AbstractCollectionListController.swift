//
//  AbstractCollectionListController.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import UIKit

public let itemsPerPage = 20
public let preloadAtItem = 10

protocol ListControlDelegate: class {
    func updateListModel(_ model: AnyObject?)
}

// MARK: - Request type
enum RequestPageType: Int {
    case first = 0, next = 1
}
/*
 Abstract Class is to define and declare all possible values which can be used without re-write the code in the main view controller
 */
class AbstractCollectionListController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CollectionCellDelegate {
    
    //Global variables
    internal var mainControl: AbstractController!
    weak var customDelegate: ListControlDelegate!
    internal var isLoading = false
    internal var page = 0
    internal var isPageAvailable = false
    internal var items: Array<Any>! = []
    fileprivate var isConnection = true
    
    //Stored variables
    internal var isNibUsed: Bool {
        return true
    }
    
    internal var isStaticData: Bool {
        return false
    }
    
    internal var cellClass: AbstractCollectionCell.Type {
        return AbstractCollectionCell.self
    }
    
    internal var reuseId: String {
        return cellClass.reuseId
    }
    
    internal var margin: CGFloat {
        return 0.0
    }
    
    // MARK: Required initialize methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        requestItemsForFirstPage()
    }
    
    // MARK: - Setup collectionview properties
    private func setupCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.setCollectionViewLayout(cellClass.flowLayout(margin), animated: true)
        if isNibUsed {
            collectionView?.register(UINib.init(nibName: String(describing: cellClass), bundle: nil), forCellWithReuseIdentifier: reuseId)
        } else {
            collectionView?.register(cellClass, forCellWithReuseIdentifier: reuseId)
        }
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.indicatorStyle = .black
        collectionView.isPagingEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView?.contentInset = .init(top: 0, left: margin, bottom: 0, right: margin)
        collectionView?.alwaysBounceVertical = false
        collectionView?.alwaysBounceHorizontal = false
        collectionView?.backgroundView = customBackgroundView
        collectionView?.addSubview(refreshControl)
        collectionView?.keyboardDismissMode = .onDrag
    }
    
    // MARK: setter getters
    private var refreshControl1: UIRefreshControl!
    internal var refreshControl: UIRefreshControl {
        get {
            if refreshControl1 == nil {
                refreshControl1 = UIRefreshControl()
                refreshControl1.addTarget(self, action: #selector(AbstractCollectionListController.refresh), for: UIControl.Event.valueChanged)
            }
            return refreshControl1
        }
        set {
            refreshControl1 = newValue
        }
    }
    
    //End refreshing
    private func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    //Refresh list
    @objc internal func refresh() {
        requestItemsForFirstPage()
    }
    
    // MARK: setters & getters
    private var _customBackgroundView: ListBackgroundView?
    private var customBackgroundView: ListBackgroundView {
        get {
            if _customBackgroundView == nil {
                _customBackgroundView = ListBackgroundView()
                _customBackgroundView?.isVisible = false
            }
            return _customBackgroundView!
        }
        set {
            _customBackgroundView = newValue
        }
    }
    
    private var _searchQuery: String!
    internal var searchQuery: String! {
        get {
            return _searchQuery ?? ""
        }
        set {
            if newValue != _searchQuery {
                _searchQuery = newValue
                requestItemsForFirstPage()
            }
        }
    }
    
    private let noInternetText: String = "No internet connection!"
    private var _noItemsText: String = ""
    internal var noItemsText: String {
        get {
            return customBackgroundView.messageText
        }
        set {
            if isConnection || newValue.count != 0 {
                customBackgroundView.messageText = newValue
                _noItemsText = newValue
            }
            if !isConnection {
                customBackgroundView.messageText = noInternetText
            }
        }
    }
    
    // MARK: Request for first page
    private func requestItemsForFirstPage() {
        if isLoading == false {
            isLoading = true
            isPageAvailable = true
            page = 1
            requestItemsForPage(.first)
        }
    }
    
    // MARK: Request for next page
    private func requestItemsForNextPage() {
        if isLoading == false && isPageAvailable == true {
            isLoading = true
            page += 1
            requestItemsForPage(.next)
        }
    }
    
    // MARK: Request with type
    private func requestItemsForPage(_ type: RequestPageType) {
        if searchQuery.count != 0 && type == .first {
            customBackgroundView.isVisible = true
            customBackgroundView.searchText = searchQuery
            items.removeAll()
            collectionView!.reloadData()
        } else {
            customBackgroundView.isVisible = false
        }
        // MARK: - Make a request
        if isConnection {//if internet
            noItemsText = _noItemsText
            weak var weakSelf = self
            requestItems(searchQuery, page: page, completion: {(items, error, pageAvailable) in
                weakSelf?.customBackgroundView.searchText = nil
                weakSelf?.isLoading = false
                weakSelf?.isPageAvailable = pageAvailable!
                weakSelf?.endRefreshing()
                if error == nil && items != nil {
                    if type == .first {
                        weakSelf?.items.removeAll()
                    }
                    weakSelf?.items.append(contentsOf: items!)
                    weakSelf?.collectionView?.reloadData()
                    weakSelf?.customBackgroundView.isVisible = (weakSelf?.items.count == 0)
                } else {
                    if type == .first && error != nil {
                        weakSelf?.items.removeAll()
                        weakSelf?.collectionView!.reloadData()
                        weakSelf?.customBackgroundView.isVisible = (weakSelf?.items.count == 0)
                    }
                }
            })
        } else {//if no internet
            customBackgroundView.searchText = nil
            isLoading = false
            isPageAvailable = false
            endRefreshing()
            noItemsText = noInternetText
            items.removeAll()
            collectionView!.reloadData()
            customBackgroundView.isVisible = true
        }
    }
    
    // MARK: - Static items
    internal var staticItems: Array<Any> {
        get {
            return items
        }
        set {
            items.removeAll()
            items.append(contentsOf: newValue)
            collectionView?.reloadData()
            isLoading = false
            isPageAvailable = false
            customBackgroundView.isVisible = (items.count == 0)
        }
    }
    
    // MARK: - Abstract request method
    internal func requestItems(_ query: String, page: Int, completion: @escaping (_ : Array<Any>?, _ : NSError?, _ : Bool?) -> Void) {
        completion(nil, nil, false); // Default implementation does almost nothing
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseId, for: indexPath) as? AbstractCollectionCell
        cell!.updateWithModel(items[indexPath.row] as AnyObject)
        cell!.delegate = self
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? AbstractCollectionCell)!.viewAppear()
        let shouldPreloadHere = indexPath.item == self.items.count - itemsPerPage + preloadAtItem
        let lastItemReached = indexPath.item == self.items.count - 1
        if shouldPreloadHere || lastItemReached {
            weak var weakSelf = self
            DispatchQueue.dispatch_async_main({ // Avoid race condition
                weakSelf?.requestItemsForNextPage()
            })
        }
    }
    
    // MARK: Cell delegate methods
    func updateCell() {
        collectionView?.reloadData()
    }
    
    func updateModel(_ model: AnyObject, cell: AbstractCollectionCell) {
        let indexPath = collectionView?.indexPathForItem(at: cell.frame.origin)
        let row: Int = (indexPath?.row)!
        self.items[row] = model
    }
}
