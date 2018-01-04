//
//  EdgedLabel.swift
//  kwikboost AR demo
//

import UIKit

/// UILabel that redraws when its edge insets change.
/// convineient to position text inside label.
open class EdgedLabel: UILabel {

    var edgeInsets: UIEdgeInsets = .zero {
        didSet { setNeedsDisplay() }
    }

    convenience init (edgeInsets: UIEdgeInsets) {
        self.init()
        self.edgeInsets = edgeInsets
    }

    open override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, edgeInsets))
    }
}
