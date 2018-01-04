//
//  ViewController.swift
//  kwikboost AR demo
//

import UIKit

class ViewController: ARViewController, ChildViewControllerDelegate {

    //UI

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(hidden: true)
    }

    /// Hide status bar for this view unless child controller is presented.
    /// In which case, ask the child controller if it wants to show/hide status bar.
    override var prefersStatusBarHidden: Bool {
        return {
            switch productsVCState {
            case .active(let child):
                return child.prefersStatusBarHidden
            case .inactive: return true
            }
        }()
    }

    //Products VC presentation.

    /// Present productsVC on button action.
    override func chooseObject(_ button: UIButton) {
        let productsVC: ProductsVC = ProductsVC()
        productsVC.childViewControllerDelegate = self
        productsVC.delegate = self

        addChild(viewController: productsVC)
        setSubviewsHidden(true)
    }

    /// Virtual Object.

    override func willLoad(object: VirtualObject, previous: VirtualObject?) {
        super.willLoad(object: object, previous: previous)

        // give new object previous object's rotation and remove previous object from scene.
        if let previous = previous {
            object.rotation = previous.rotation
            previous.removeFromParentNode()
        }
    }

    // ChildViewControllerDelegate

    func willDisplayChild(controller: UIViewController) {
        controller is ProductsVC ? productsVCState = .active(controller) : ()
        title = controller.title
        setNavigationBar(hidden: false)
    }

    func willRemoveChild(controller: UIViewController) {
        controller is ProductsVC ? productsVCState = .inactive: ()
        title = nil // title is not visible in this controller.
        setNavigationBar(hidden: true)
        setSubviewsHidden(false)
    }

    // Private

    private func setSubviewsHidden(_ hidden: Bool) {
        let value: CGFloat = hidden ? 0 : 1
        messagePanel.alpha = value
        messageLabel.alpha = value
        settingsButton.alpha = value
        addObjectButton.alpha = value
        restartExperienceButton.alpha = value
    }

    // Should only be set in two places, when presenting and removing productsVC.
    private var productsVCState: PruductsVCState = .inactive

    private enum PruductsVCState {
        case active(UIViewController)
        case inactive
    }
}
