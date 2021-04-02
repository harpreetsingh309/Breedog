//
//  AbstractController.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import UIKit

class AbstractController: UIViewController, ListControlDelegate {
    
    // MARK: - IBOutlets and Variables
    // List container to show list control for table and collection view.
    @IBOutlet var listContainer: UIView!
    
    var model: AnyObject!
    
    // MARK: - Get control from storyboard.
    class var control: AbstractController {
        return (UIStoryboard.main.instantiateViewController(withIdentifier: String(describing: self)) as? AbstractController)!
    }
    
    class func controlWithModel(_ model: AnyObject) -> AbstractController {
        let control = self.control
        control.model = model
        return control
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initListControl()
        addObserverForAppState()
    }
    
    func addObserverForAppState() {
        NotificationCenter.default.addObserver(self, selector: #selector(appEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: - Background Foreground Notification
    @objc func appEnterBackground() {}
    
    @objc func appEnterForeground() {}
    
    deinit {
        debugPrint("Super of \(String(describing: self)) released.")
        NotificationCenter.default.removeObserver(self)
    }
    
    func initListControl() {
        if listContainer != nil {
            if collectionControl != nil {
                customAddChildViewController(collectionControl, toSubview: listContainer)
            }
        } else {
            if collectionControl != nil {
                listContainer = UIView()
                view.addSubview(listContainer)
                view.addVisualConstraints(["H:|[list]|", "V:|[list]|"], subviews: ["list": listContainer])
                initListControl()
            }
        }
    }
    
    // MARK: - Can be override in child controls.
    var collectionClass: AbstractCollectionListController.Type! {
        return nil
    }
    
    // MARK: - Setter getter methods
    private var _collectionControl: AbstractCollectionListController!
    var collectionControl: AbstractCollectionListController! {
        if collectionClass == nil {
            return nil
        }
        if _collectionControl == nil {
            _collectionControl = collectionClass.init(collectionViewLayout: UICollectionViewLayout())
            _collectionControl.customDelegate = self
            _collectionControl.mainControl = self
        }
        return _collectionControl
    }
    
    func updateListModel(_ model: AnyObject?) {}
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func releaseCollection() {
        if _collectionControl != nil {
            collectionControl.customRemoveFromParentViewController()
            collectionControl.customDelegate = nil
            _collectionControl = nil
        }
    }
    
    // MARK: - Misc
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
