//
//  NKIconLabel.swift
//  NKComponents
//
//  Created by Nam Kennic on 8/16/19.
//  Copyright © 2019 Nam Kennic. All rights reserved.
//

import UIKit

public enum NKIconVerticalAlignment {
	case top
	case center
	case bottom
}

public enum NKIconHorizontalAlignment {
	case left
	case center
	case right
}

public enum NKIconLabelImageAlignment {
	case left(verticalAlignment: NKIconVerticalAlignment = .center)
	case right(verticalAlignment: NKIconVerticalAlignment = .center)
	case top(horizontalAlign: NKIconHorizontalAlignment = .center)
	case bottom(horizontalAlign: NKIconHorizontalAlignment = .center)
}

open class NKIconLabel: UILabel {
	public let imageView = UIImageView()
	public var spacing: CGFloat = 5.0 {
		didSet {
			setNeedsLayout()
			setNeedsDisplay()
		}
	}
	
	public var image: UIImage? {
		get { imageView.image }
		set {
			imageView.image = newValue
			setNeedsDisplay()
			setNeedsLayout()
		}
	}
	
	public var imageAlignment: NKIconLabelImageAlignment = .left(verticalAlignment: .center) {
		didSet {
			setNeedsDisplay()
			setNeedsLayout()
		}
	}
	
	public var maxImageSize: CGSize = .zero
	
	public var extendSize: CGSize = .zero
	public var edgeInsets: UIEdgeInsets = .zero {
		didSet {
			setNeedsDisplay()
			setNeedsLayout()
		}
	}
	
	public init() {
		super.init(frame: .zero)
		
		imageView.contentMode = .scaleAspectFit
		addSubview(imageView)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override open func drawText(in rect: CGRect) {
		guard let iconSize = imageView.image?.size else {
			super.drawText(in: rect)
			return
		}
		
		var textInsets: UIEdgeInsets = .zero
		let maxWidth = maxImageSize.width > 0 ? min(iconSize.width, maxImageSize.width) : iconSize.width
		let maxHeight = maxImageSize.height > 0 ? min(iconSize.height, maxImageSize.height) : iconSize.height
		
		switch imageAlignment {
			case .left(_): textInsets = UIEdgeInsets(top: edgeInsets.top, left: edgeInsets.left + maxWidth + spacing, bottom: edgeInsets.bottom, right: edgeInsets.right)
			case .right(_): textInsets = UIEdgeInsets(top: edgeInsets.top, left: edgeInsets.left, bottom: edgeInsets.bottom, right: edgeInsets.right + maxWidth + spacing)
			case .top(_): textInsets = UIEdgeInsets(top: edgeInsets.top + maxHeight + spacing, left: edgeInsets.left, bottom: edgeInsets.bottom, right: edgeInsets.right)
			case .bottom(_): textInsets = UIEdgeInsets(top: edgeInsets.top, left: edgeInsets.left, bottom: edgeInsets.bottom + maxHeight + spacing, right: edgeInsets.right)
		}
		
		let textRect = bounds.inset(by: textInsets)
		super.drawText(in: textRect)
	}
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		
		guard let iconSize = imageView.image?.size else { return }
		let maxWidth = maxImageSize.width > 0 ? min(iconSize.width, maxImageSize.width) : iconSize.width
		let maxHeight = maxImageSize.height > 0 ? min(iconSize.height, maxImageSize.height) : iconSize.height
		let viewSize = bounds.size
		
		var imageFrame: CGRect
		switch imageAlignment {
			case .left(let verticalAlignment):
				let frameY = verticalAlignment == .top ? edgeInsets.top : verticalAlignment == .bottom ? (viewSize.height - maxHeight) : (viewSize.height - maxHeight)/2
				imageFrame = CGRect(x: edgeInsets.left, y: frameY, width: maxWidth, height: maxHeight)
			
			case .right(let verticalAlignment):
				let frameY = verticalAlignment == .top ? edgeInsets.top : verticalAlignment == .bottom ? (viewSize.height - maxHeight) : (viewSize.height - maxHeight)/2
				imageFrame = CGRect(x: viewSize.width - maxWidth - edgeInsets.right, y: frameY, width: maxWidth, height: maxHeight)
			
			case .top(let horizontalAlignment):
				let frameX = horizontalAlignment == .left ? edgeInsets.left : horizontalAlignment == .right ? (viewSize.width - maxWidth) : (viewSize.width - maxWidth)/2
				imageFrame = CGRect(x: frameX, y: edgeInsets.top, width: maxWidth, height: maxHeight)
			
			case .bottom(let horizontalAlignment):
				let frameX = horizontalAlignment == .left ? edgeInsets.left : horizontalAlignment == .right ? (viewSize.width - maxWidth) : (viewSize.width - maxWidth)/2
				imageFrame = CGRect(x: frameX, y: viewSize.height - maxHeight - edgeInsets.bottom, width: maxWidth, height: maxHeight)
		}
		
		imageView.frame = imageFrame
	}
	
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		let superValue = super.sizeThatFits(size)
        let iconSize = imageView.image?.size ?? .zero
        let spacingValue = iconSize == .zero ? 0.0 : spacing

		let imageWidth = maxImageSize.width > 0 ? min(iconSize.width, maxImageSize.width) : iconSize.width
		let imageHeight = maxImageSize.height > 0 ? min(iconSize.height, maxImageSize.height) : iconSize.height
		
		var result: CGSize
		switch imageAlignment {
			case .left(_), .right(_): result = CGSize(width: superValue.width + spacingValue + imageWidth, height: max(imageHeight, superValue.height))
			case .top(_), .bottom(_): result = CGSize(width: max(imageWidth, superValue.width), height: superValue.height + spacingValue + imageHeight)
		}
		
		result.width += edgeInsets.left + edgeInsets.right + extendSize.width
		result.height += edgeInsets.top + edgeInsets.bottom + extendSize.height
		return result
	}
	
}
