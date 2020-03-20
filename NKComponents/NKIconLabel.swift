//
//  NKIconLabel.swift
//  NKComponents
//
//  Created by Nam Kennic on 8/16/19.
//  Copyright © 2019 Nam Kennic. All rights reserved.
//

import UIKit

public enum NKIconLabelImageAlignment {
	case left
	case right
}

public class NKIconLabel: UILabel {
	public let imageView = UIImageView()
	public var spacing: CGFloat = 5.0 {
		didSet {
			setNeedsLayout()
			setNeedsDisplay()
		}
	}
	
	public var image: UIImage? {
		get {
			return imageView.image
		}
		set {
			imageView.image = newValue
			setNeedsDisplay()
			setNeedsLayout()
		}
	}
	
	public var imageAlignment: NKIconLabelImageAlignment = .left {
		didSet {
			setNeedsDisplay()
			setNeedsLayout()
		}
	}
	
	public var maxImageSize: CGSize = CGSize(width: 32, height: 32)
	
	public var extendSize: CGSize = .zero
	public var edgeInsets: UIEdgeInsets = .zero {
		didSet {
			setNeedsDisplay()
			setNeedsLayout()
		}
	}
	
	init() {
		super.init(frame: .zero)
		
		imageView.contentMode = .scaleAspectFit
		addSubview(imageView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override open func drawText(in rect: CGRect) {
		guard let iconSize = imageView.image?.size else {
			super.drawText(in: rect)
			return
		}
		
		let textInsets = imageAlignment == .left ? 	UIEdgeInsets(top: edgeInsets.top, left: edgeInsets.left + min(iconSize.width, maxImageSize.width) + spacing, bottom: edgeInsets.bottom, right: edgeInsets.right) :
													UIEdgeInsets(top: edgeInsets.top, left: edgeInsets.left, bottom: edgeInsets.bottom, right: edgeInsets.right + min(iconSize.width, maxImageSize.width) + spacing)
		let textRect = bounds.inset(by: textInsets)
		super.drawText(in: textRect)
	}
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		
		guard let iconSize = imageView.image?.size else { return }
		let imageMaxSize = CGSize(width: min(iconSize.width, maxImageSize.width), height: min(iconSize.height, maxImageSize.height))
		let viewSize = bounds.size
		
		if imageAlignment == .left {
			imageView.frame = CGRect(x: edgeInsets.left, y: (viewSize.height - imageMaxSize.height)/2, width: imageMaxSize.width, height: imageMaxSize.height)
		}
		else {
			imageView.frame = CGRect(x: viewSize.width - imageMaxSize.width - edgeInsets.right, y: (viewSize.height - imageMaxSize.height)/2, width: imageMaxSize.width, height: imageMaxSize.height)
		}
	}
	
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		let superValue = super.sizeThatFits(size)
        let iconSize = imageView.image?.size ?? .zero
        let spacingValue = iconSize == .zero ? 0.0 : spacing

		let imageMaxSize = CGSize(width: min(iconSize.width, maxImageSize.width), height: min(iconSize.height, maxImageSize.height))
		return CGSize(width: superValue.width + spacingValue + imageMaxSize.width + edgeInsets.left + edgeInsets.right + extendSize.width, height: max(imageMaxSize.height, superValue.height) + edgeInsets.top + edgeInsets.bottom + extendSize.height)
	}
	
}
