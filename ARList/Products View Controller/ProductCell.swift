//
//  ProductCell.swift
//  kwikboost AR demo
//

import UIKit

/// Final ProductCell class. Change the static id if opening this to subclasses.
final class ProductCell: UICollectionViewCell {
    static let id: String = "ProductCellId"
    static let height: CGFloat = 350
    /*
    was:  static let height: CGFloat = 120 for Chris' phone, needs to be made dynamic
    changed to: let height: CGFloat = 100 * 400 / UIScreen.main.bounds.height
    iPhone8 resolution: 750x1334
    ipad 10" resolution: 834x1112
    iPhone = .562 height ratio
    iPad = .75 height ratio
    */
    
    struct Model {
        let title: String
        let image: UIImage?
    }

    /// Cell model. Updates ui upon set.
    var model: Model? { didSet { updateUI() } }

    // Views

    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .clear
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()

    lazy var backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .cyan
        imageView.clipsToBounds = true 
        return imageView
    }()

    // Init and layout.

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(backgroundImageView, titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.frame = bounds

        backgroundImageView.frame = bounds
    }

    // Private

    private func updateUI() {
        titleLabel.text = model?.title ?? "not set"
        backgroundImageView.image = model?.image
    }
}
