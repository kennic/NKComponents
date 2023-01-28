//
//  NKGridLineView.swift
//  NKComponents
//
//  Created by Nam Kennic on 8/16/19.
//  Copyright © 2019 Nam Kennic. All rights reserved.
//

import UIKit

open class NKGridLineView: UIView {
	
	public var lineColor: UIColor = .lightGray {
		didSet { setNeedsDisplay() }
	}
	
	public var lineSize: CGFloat = 1.0 {
		didSet { setNeedsDisplay() }
	}
	
	public var lineDash: (phase: CGFloat, lengths: [CGFloat]) = (0, []) {
		didSet { setNeedsDisplay() }
	}
	
	public var numberOfHorizontalLines: Int = 0 {
		didSet { setNeedsDisplay() }
	}
	
	public var numberOfVerticalLines: Int = 0 {
		didSet { setNeedsDisplay() }
	}
	
	public var edgeInsets: UIEdgeInsets = .zero {
		didSet { setNeedsDisplay() }
	}
	
	override public var frame: CGRect {
		didSet { setNeedsDisplay() }
	}
	
	override public var bounds: CGRect {
		didSet { setNeedsDisplay() }
	}
	
	public init() {
		super.init(frame: .zero)
		
		backgroundColor = .clear
		isUserInteractionEnabled = false
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override open func draw(_ rect: CGRect) {
		super.draw(rect)
		
		guard let context = UIGraphicsGetCurrentContext() else { return }
		
		let drawBounds = bounds.inset(by: edgeInsets)
		let viewSize = drawBounds.size
		
		context.saveGState()
		context.clear(bounds)
		context.setStrokeColor(lineColor.cgColor)
		context.setLineWidth(lineSize)
		
		if !lineDash.lengths.isEmpty {
			context.setLineDash(phase: lineDash.phase, lengths: lineDash.lengths)
		}
		
		if numberOfVerticalLines > 0 {
			let steps = viewSize.width / CGFloat(numberOfVerticalLines + 1)
			for x in 1...numberOfVerticalLines {
				let lineX = drawBounds.minX + (CGFloat(x) * steps)
				let startPoint = CGPoint(x: lineX, y: drawBounds.minY)
				let endPoint = CGPoint(x: lineX, y: drawBounds.maxY)
				context.move(to: startPoint)
				context.addLine(to: endPoint)
				context.strokePath()
			}
		}
		
		if numberOfHorizontalLines > 0 {
			let steps = viewSize.height / CGFloat(numberOfHorizontalLines + 1)
			for y in 1...numberOfHorizontalLines {
				let lineY = drawBounds.minY + (CGFloat(y) * steps)
				let startPoint = CGPoint(x: drawBounds.minX, y: lineY)
				let endPoint = CGPoint(x: drawBounds.maxX, y: lineY)
				context.move(to: startPoint)
				context.addLine(to: endPoint)
				context.strokePath()
			}
		}
		
		context.restoreGState()
	}
	
}
