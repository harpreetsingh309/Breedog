//
//  Extensions.swift
//  Breedog
//
//  Created by macexpert on 02/04/21.
//

import UIKit

// MARK: - UIApplication
extension UIApplication {
    
    class var scene: UIViewController! {
        let sceneDelegate = UIApplication.shared.connectedScenes
            .first!.delegate as! SceneDelegate
        return sceneDelegate.window?.rootViewController
    }
    
    class var appWindow: UIWindow! {
        return (UIApplication.shared.delegate?.window!)!
    }
    
    class var rootViewController: UIViewController! {
        if #available(iOS 13.0, *) {
            return self.scene
        }
        return self.appWindow.rootViewController!
    }
    
    class var visibleViewController: UIViewController! {
        return self.rootViewController.findContentViewControllerRecursively()
    }
    
}

//MARK:- UIScreen
extension UIScreen {

    class var mainBounds: CGRect {
        return main.bounds
    }
    
    class var mainSize: CGSize {
        return mainBounds.size
    }
    
}

//MARK:- DispatchQueue
extension DispatchQueue {
    class func dispatch_async_main(_ block: @escaping () -> Void) {
        self.main.async(execute: block)
    }
}

//MARK:- String
extension String {
    var length: Int {
        return count
    }
}

//MARK:- UIView
extension UIView {
    
    var isVisible: Bool {
        get {
            return !isHidden
        }
        set {
            DispatchQueue.dispatch_async_main {
                self.isHidden = !newValue
            }
        }
    }
    
    func addSubviews(_ subviews: [UIView]) {
        for view in subviews {
            addSubview(view)
        }
    }
    
    func addConstraint(_ view1: UIView, view2: UIView, att1: NSLayoutConstraint.Attribute, att2: NSLayoutConstraint.Attribute, mul: CGFloat, const: CGFloat) -> NSLayoutConstraint {
        if view2.responds(to: #selector(setter: self.translatesAutoresizingMaskIntoConstraints)) {
            view2.translatesAutoresizingMaskIntoConstraints = false
        }
        let constraint = NSLayoutConstraint(item: view1, attribute: att1, relatedBy: .equal, toItem: view2, attribute: att2, multiplier: mul, constant: const)
        addConstraint(constraint)
        return constraint
    }

    func addVisualConstraints(_ constraints: [String], metrics: [String: Any]?, subviews: [String: UIView]) {
        // Disable autoresizing masks translation for all subviews
        for subview in subviews.values {
            if subview.responds(to: #selector(setter: self.translatesAutoresizingMaskIntoConstraints)) {
                subview.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        // Apply all constraints
        for constraint in constraints {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraint, options: [], metrics: metrics, views: subviews))
        }
    }
    
    func addConstraint(_ view: UIView, att1: NSLayoutConstraint.Attribute, att2: NSLayoutConstraint.Attribute, mul: CGFloat, const: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: att1, relatedBy: .equal, toItem: view, attribute: att2, multiplier: mul, constant: const)
        addConstraint(constraint)
        return constraint
    }
    
    func addConstraintSameCenterX(_ view1: UIView, view2: UIView) {
        _ = addConstraint(view1, view2: view2, att1: .centerX, att2: .centerX, mul: 1.0, const: 0.0)
    }
    
    func addConstraintSameCenterY(_ view1: UIView, view2: UIView) {
        _ = addConstraint(view1, view2: view2, att1: .centerY, att2: .centerY, mul: 1.0, const: 0.0)
    }
    
    func addConstraintSameCenterXY(_ view1: UIView, and view2: UIView) {
        addConstraintSameCenterX(view1, view2: view2)
        addConstraintSameCenterY(view1, view2: view2)
    }
        
    func addConstraintToFillSuperview() {
        superview?.addVisualConstraints(["H:|[self]|", "V:|[self]|"], subviews: ["self": self])
    }
    
    func addVisualConstraints(_ constraints: [String], subviews: [String: UIView]) {
        addVisualConstraints(constraints, metrics: nil, subviews: subviews)
    }
}

// MARK: - Storyboard
extension UIStoryboard {
    
    class var main: UIStoryboard {
        let storyboardName: String = (Bundle.main.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String)!
        return UIStoryboard(name: storyboardName, bundle: nil)
    }
}

// MARK: - View Controller
extension UIViewController {
    
    func isPresentedModally() -> Bool {
        return self.presentingViewController?.presentedViewController == self
    }

    func popOrDismissViewController(_ animated: Bool) {
          if self.isPresentedModally() {
              self.dismiss(animated: animated, completion: nil)
          } else if self.navigationController != nil {
              _ = self.navigationController?.popViewController(animated: animated)
          }
      }
    
    func customAddChildViewController(_ child: UIViewController, toSubview subview: UIView) {
        self.addChild(child)
        subview.addSubview(child.view)
        child.view.addConstraintToFillSuperview()
        child.didMove(toParent: self)
    }
    
    func customRemoveFromParentViewController() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    func findContentViewControllerRecursively() -> UIViewController {
        var childViewController: UIViewController?
        if self is UITabBarController {
            childViewController = (self as? UITabBarController)?.selectedViewController
        } else if self is UINavigationController {
            childViewController = (self as? UINavigationController)?.topViewController
        } else if self is UISplitViewController {
            childViewController = (self as? UISplitViewController)?.viewControllers.last
        } else if self.presentedViewController != nil {
            childViewController = self.presentedViewController
        }
        let shouldContinueSearch: Bool = (childViewController != nil) && !((childViewController?.isKind(of: UIAlertController.self))!)
        return shouldContinueSearch ? childViewController!.findContentViewControllerRecursively() : self
    }
}
