//
//  ProductsVC.swift
//  kwikboost AR demo
//

import UIKit

class ProductsVC: ChildViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    private var selectedVirtualObjectRows = IndexSet()
    weak var delegate: VirtualObjectSelectionViewControllerDelegate?

    private let shouldShowCellSelectionFeedback: Bool = true
    private let shouldHideStatusBar: Bool = false

    //// static struct. holds ui constants.
    struct Constants {
        private init() {}

        static let headerTitleLabelFont = UIFont.boldSystemFont(ofSize: 18)
        static let headerTitleLabelEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        static let headerTitleLabelHeight: CGFloat = 60
        static let barTitleAttributes: [NSAttributedStringKey : UIColor] = [.foregroundColor: .white]
        static let barTintColor: UIColor = .brown
        static let cancelButtonColor: UIColor = .white
        static let backgroundColor: UIColor = .white
    }

    // Views

    lazy var headerTitleLabel: EdgedLabel = {
        let textView: EdgedLabel = EdgedLabel()
        textView.isUserInteractionEnabled = false
        textView.text = .shopByCategory
        textView.textColor = .darkGray
        textView.adjustsFontForContentSizeCategory = true
        textView.font = Constants.headerTitleLabelFont

        return textView
    }()

    lazy var productsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.productsCollectionViewFrame.width, height: ProductCell.height)
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Constants.backgroundColor

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.id)

        return collectionView
    }()

    let selectedCellFeedbackView: UIView = {
        let shade: UIView = UIView()
        shade.backgroundColor = UIColor.black
        shade.alpha = 0.7
        return shade
    }()

    // Frames

    var headerTitleLabelFrame: CGRect {
        return CGRect(x: 0, y: topBarsHeight, width: view.bounds.width, height: Constants.headerTitleLabelHeight)
    }

    var productsCollectionViewFrame: CGRect {
        var frame = view.bounds
        frame.origin.y = headerTitleLabelFrame.bottomY
        frame.size.height -= headerTitleLabelFrame.bottomY
        return frame
    }

    // Init

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = .products
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.backgroundColor
        view.addSubviews(headerTitleLabel, productsCollectionView)

        navigationController?.navigationBar.titleTextAttributes = Constants.barTitleAttributes
        navigationController?.navigationBar.barTintColor = Constants.barTintColor

        let cancelBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: .cancel, style: .done, target: self, action: #selector(presentParentViewController))
        cancelBarButtonItem.tintColor = Constants.cancelButtonColor
        navigationItem.setLeftBarButton(cancelBarButtonItem, animated: false)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        productsCollectionView.frame = productsCollectionViewFrame

        headerTitleLabel.frame = headerTitleLabelFrame
        headerTitleLabel.edgeInsets = Constants.headerTitleLabelEdgeInsets
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        selectedCellFeedbackView.removeFromSuperview()
    }

    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }

    // Actions

    @objc func presentParentViewController() {
        removeFromParent()
    }

    // UICollectionViewDataSource

    let dataSource: DataSource = DataSource(virtualObjectDefinitions: VirtualObjectManager.availableObjects)

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.id, for: indexPath)
    }

    // UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let productCell = cell as? ProductCell else { return }
        let model: ProductCell.Model = {
            let title: String = dataSource.titleForObject(at: indexPath.row) ?? "Not set"
            let image: UIImage? = dataSource.thumbnailForObject(at: indexPath.row)
            return ProductCell.Model(title: title, image: image)
        }()
        productCell.model = model
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Check if the current row is already selected, then deselect it.
        if selectedVirtualObjectRows.contains(indexPath.row) {
            delegate?.virtualObjectSelectionViewController(nil, didDeselectObjectAt: indexPath.row)
        } else {
            delegate?.virtualObjectSelectionViewController(nil, didSelectObjectAt: indexPath.row)
        }

        if shouldShowCellSelectionFeedback {
            showSelectionFeedbackForCel(at: indexPath)
        }

        presentParentViewController()
    }

    // Private

    private func showSelectionFeedbackForCel(at indexPath: IndexPath) {
        let cell = productsCollectionView.cellForItem(at: indexPath)!
        selectedCellFeedbackView.removeFromSuperview()
        selectedCellFeedbackView.frame = cell.bounds
        cell.addSubview(selectedCellFeedbackView)
    }

    // Mock data source
    
    class DataSource {
        let objects: [VirtualObjectDefinition]

        var count: Int { return objects.count }

        init(virtualObjectDefinitions: [VirtualObjectDefinition]) {
            self.objects = virtualObjectDefinitions
        }

        func titleForObject(at index: Int) -> String? {
            guard index < objects.count else { return nil }
            return objects[index].displayName
        }

        func thumbnailForObject(at index: Int) -> UIImage? {
            guard index < objects.count else { return nil }
            let imageName: String = "\(objects[index].displayName)1".lowercased()
            return UIImage(named: imageName)
        }
    }
}



