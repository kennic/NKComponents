//
//  NKTitleLabel.swift
//  NKComponents
//
//  Created by Nam Kennic on 5/25/20.
//  Copyright © 2020 Nam Kennic. All rights reserved.
//

import UIKit

public enum NKTitleLabelAlignment {
	case left
	case right
}

open class NKTitleLabel: UILabel {
	open var titleLabel = NKIconLabel()
	public var spacing: CGFloat = 5.0 {
		didSet {
			setNeedsLayout()
			setNeedsDisplay()
		}
	}
	
	public var title: String? {
		get { titleLabel.text }
		set {
			titleLabel.text = newValue
			setNeedsLayout()
		}
	}
	
	public var titleImage: UIImage? {
		get { titleLabel.image }
		set {
			titleLabel.image = newValue
			setNeedsDisplay()
			setNeedsLayout()
		}
	}
	
	public var titleFont: UIFont {
		get { titleLabel.font }
		set {
			titleLabel.font = newValue
			setNeedsLayout()
		}
	}
	
	public var titleColor: UIColor {
		get { titleLabel.textColor }
		set { titleLabel.textColor = newValue }
	}
	
	public var titleTextAlignment: NSTextAlignment {
		get { titleLabel.textAlignment }
		set { titleLabel.textAlignment = newValue }
	}
	
	public var titleAlignment: NKTitleLabelAlignment = .left {
		didSet {
			setNeedsDisplay()
			setNeedsLayout()
		}
	}
	
	public var maxTitleSize: CGSize = .zero
	
	public var extendSize: CGSize = .zero
	public var edgeInsets: UIEdgeInsets = .zero {
		didSet {
			setNeedsDisplay()
			setNeedsLayout()
		}
	}
	
	public init() {
		super.init(frame: .zero)
		
		titleLabel.contentMode = .scaleAspectFit
		addSubview(titleLabel)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override open func drawText(in rect: CGRect) {
		let titleLabelSize = titleSizeThatFits(rect.size)
		let textInsets = titleAlignment == .left ? 	UIEdgeInsets(top: edgeInsets.top, left: edgeInsets.left + titleLabelSize.width + spacing, bottom: edgeInsets.bottom, right: edgeInsets.right) :
			UIEdgeInsets(top: edgeInsets.top, left: edgeInsets.left, bottom: edgeInsets.bottom, right: edgeInsets.right + titleLabelSize.width + spacing)
		let textRect = bounds.inset(by: textInsets)
		super.drawText(in: textRect)
	}
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		
		let viewSize = bounds.size
		let titleLabelSize = titleSizeThatFits(viewSize)
		
		if titleAlignment == .left {
			titleLabel.frame = CGRect(x: edgeInsets.left, y: (viewSize.height - titleLabelSize.height)/2, width: titleLabelSize.width, height: titleLabelSize.height)
		}
		else {
			titleLabel.frame = CGRect(x: viewSize.width - titleLabelSize.width - edgeInsets.right, y: (viewSize.height - titleLabelSize.height)/2, width: titleLabelSize.width, height: titleLabelSize.height)
		}
	}
	
	func titleSizeThatFits(_ size: CGSize) -> CGSize {
		var result = titleLabel.sizeThatFits(size)
		if maxTitleSize.width > 0 {
			result.width = min(maxTitleSize.width, result.width)
		}
		if maxTitleSize.height > 0 {
			result.height = min(maxTitleSize.height, result.height)
		}
		
		return result
	}
	
	override open func sizeThatFits(_ size: CGSize) -> CGSize {
		let superValue = super.sizeThatFits(size)
		let titleLabelSize = titleSizeThatFits(size)
		let spacingValue = titleLabelSize == .zero ? 0.0 : spacing
		
		return CGSize(width: superValue.width + spacingValue + titleLabelSize.width + edgeInsets.left + edgeInsets.right + extendSize.width, height: max(titleLabelSize.height, superValue.height) + edgeInsets.top + edgeInsets.bottom + extendSize.height)
	}
	
}
