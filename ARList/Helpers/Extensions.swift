//
//  Extensions.swift
//  kwikboost AR demo
//

import UIKit

extension UIViewController {

    /// Top bars height. status bar + navigation bar (if they exist and appear).
    var topBarsHeight: CGFloat {
        let statusHeight: CGFloat = UIApplication.shared.isStatusBarHidden ? 0 :
            UIApplication.shared.statusBarFrame.height
        let navBarHeight: CGFloat = (navigationController?.isNavigationBarHidden ?? true) ? 0 :
            navigationController!.navigationBar.bounds.height

        return statusHeight + navBarHeight
    }

    /// The default transition animation duration used by UINavigationController.
    var navigationTransitionAnimationDuration: TimeInterval { return 0.33 }

    /// Add given view controller as child covering `self's` entire bounds or inside given frame.
    ///
    /// - Parameters:
    ///   - child: child view controller.
    ///   - animated: true by default. navigation push like animation.
    ///   - frame: child controller's view frame.
    func addChild(viewController child: UIViewController, animated: Bool = true, frame: CGRect? = nil) {
        addChildViewController(child)
        child.view.frame = frame ?? view.bounds
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)

        guard animated else { return }
        
        child.view.frame.origin.x = view.bounds.width
        navigationController?.navigationBar.frame.origin.x = view.bounds.width
        UIView.animate(withDuration: navigationTransitionAnimationDuration) { [weak self] in
            child.view.frame.origin.x = 0
            self?.navigationController?.navigationBar.frame.origin.x = 0
        }
    }

    /// Hide navigation bar, without animation by default.
    func setNavigationBar(hidden: Bool, animated: Bool = false) {
        navigationController?.setNavigationBarHidden(hidden, animated: animated)
    }
}

extension UIView {

    /// Convenient shortcut to add array of subviews in order.
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview(_:))
    }
}

extension CGRect {

    /// origin.y + height.
    var bottomY: CGFloat {
        return origin.y + height
    }
}




