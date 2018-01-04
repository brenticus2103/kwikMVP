//
//  ChildViewController.swift
//  kwikboost AR demo
//

import UIKit

/// Notification on child view controller's life cycle.
protocol ChildViewControllerDelegate: class {

    /// Called right after UIViewController's `willMove(toParentViewController` call.
    func willDisplayChild(controller: UIViewController)

    /// Called right after UIViewController's `removeFromParentViewController()` call.
    func willRemoveChild(controller: UIViewController)
}

/// Super class for any view controller presented as child.
/// Gives access to parent's navigation controller, notifies changes in its lifecycle
/// and ensures touch events don't pass through to parent controller's view.
///
open class ChildViewController: UIViewController {
    
    weak var childViewControllerDelegate: ChildViewControllerDelegate?

    override open var navigationController: UINavigationController? {
        return parent?.navigationController ?? super.navigationController
    }

    override open var navigationItem: UINavigationItem {
        return parent?.navigationItem ?? super.navigationItem
    }

    override open func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        childViewControllerDelegate?.willDisplayChild(controller: self)
    }

    override open func removeFromParentViewController() {
        super.removeFromParentViewController()
        childViewControllerDelegate?.willRemoveChild(controller: self)
    }

    /// Remove `self` from it's parent controller if `parent` exists.
    /// Default animation similar to navigation controller's pop transition animation.
    func removeFromParent(animated: Bool = true) {
        guard parent != nil else { return }

        func remove() {
            view.removeFromSuperview()
            removeFromParentViewController()
        }

        guard animated else {
            remove()
            return
        }

        UIView.animate(withDuration: navigationTransitionAnimationDuration, animations: {
            self.view.frame.origin.x = self.view.bounds.width
            self.navigationController?.navigationBar.frame.origin.x = self.view.bounds.width
        }) { _ in
            remove()
        }
    }

    // Ignore all touch events. This will prevent touche events from propagating down to parent controller's view.
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}


