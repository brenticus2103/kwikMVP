/*
//  kwikboost AR demo

Abstract:
SceneKit node wrapper for plane geometry detected in AR.
*/

import Foundation
import ARKit

class Plane: SCNNode {
    
    // Properties
    
	var anchor: ARPlaneAnchor
	var focusSquare: FocusSquare?
    
    // Initialization
    
	init(_ anchor: ARPlaneAnchor) {
		self.anchor = anchor
		super.init()
    }
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    // ARKit
	
	func update(_ anchor: ARPlaneAnchor) {
		self.anchor = anchor
	}
		
}

