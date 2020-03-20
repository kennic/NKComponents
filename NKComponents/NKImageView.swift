//
//  NKImageView.swift
//  NKComponents
//
//  Created by Nam Kennic on 7/12/19.
//  Copyright © 2019 Nam Kennic. All rights reserved.
//

import UIKit

open class NKImageView: UIImageView {
	
	open var alwaysReturnTrueImageSize = false

	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		guard let image = image else { return .zero }
		
		let imageSize = image.size
		if alwaysReturnTrueImageSize {
			return imageSize
		}
		
		var result = size
		result.height = (size.width / imageSize.width) * imageSize.height
		
		if contentMode == .scaleAspectFit {
			if result.height > size.height {
				result.width = (size.height / imageSize.height) * imageSize.width
				result.height = size.height
			}
		}
		
		return result
	}

}
