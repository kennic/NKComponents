//
//  NKTextView.swift
//  beCustomer
//
//  Created by Nam Kennic on 8/21/19.
//  Copyright © 2019 Be Group. All rights reserved.
//

import UIKit

open class NKTextView: UITextView, UITextViewDelegate {
	let placeholderLabel = NKIconLabel()
	
	override open var font: UIFont? {
		didSet {
			placeholderLabel.font = font
			setNeedsLayout()
			layoutIfNeeded()
		}
	}
	
	open var placeholder: String? {
		didSet {
			placeholderLabel.text = placeholder
			setNeedsLayout()
			layoutIfNeeded()
		}
	}
	
	open var placeholderInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5) {
		didSet {
			setNeedsLayout()
			layoutIfNeeded()
		}
	}
	
	open var placeholderAlignment: NSTextAlignment = .left {
		didSet {
			placeholderLabel.textAlignment = placeholderAlignment
		}
	}
	
	open var placeholderColor: UIColor = .gray {
		didSet {
			placeholderLabel.textColor = placeholderColor
		}
	}
	
	override open var textAlignment: NSTextAlignment {
		didSet {
			placeholderLabel.textAlignment = textAlignment
		}
	}
	
	override open var text: String! {
		didSet {
			placeholderLabel.isHidden = !text.isEmpty
		}
	}
	
	/** Shadow radius */
	open var shadowRadius : CGFloat = 0 {
		didSet {
			if shadowRadius != oldValue {
				setNeedsDisplay()
			}
		}
	}
	
	/** Shadow opacity */
	open var shadowOpacity : Float = 0.5 {
		didSet {
			if shadowOpacity != oldValue {
				setNeedsDisplay()
			}
		}
	}
	
	/** Shadow offset */
	open var shadowOffset : CGSize = .zero {
		didSet {
			if shadowOffset != oldValue {
				setNeedsDisplay()
			}
		}
	}
	
	open var cornerRadius : CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			if layer.cornerRadius != newValue {
				layer.cornerRadius = newValue
				setNeedsDisplay()
				setNeedsLayout()
			}
		}
	}
	
	override open var frame: CGRect {
		didSet {
			guard !frame.equalTo(oldValue) else { return }
			setNeedsDisplay()
			setNeedsLayout()
		}
	}
	
	open fileprivate(set) var isEditing: Bool = false {
		didSet {
			setNeedsDisplay()
			setNeedsLayout()
		}
	}
	
	open var didTouchedLink:((URL, NSRange, CGPoint) -> Void)?
	
	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = Array(touches)[0]
		if let view = touch.view {
			let point = touch.location(in: view)
			self.tapped(on: point)
		}
	}
	
	open var maximumCharacters: Int = 0
	
    fileprivate let highlightedLayer    = CAShapeLayer()
	fileprivate var bgColorDict         : [String : UIColor] = [:]
	fileprivate var borderColorDict     : [String : UIColor] = [:]
	fileprivate var borderSizeDict      : [String : CGFloat] = [:]
    fileprivate var highlightColorDict  : [String : UIColor] = [:]
    fileprivate var highlightSizeDict   : [String : CGFloat] = [:]
	
	// MARK: -
	
	override public init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		
		backgroundColor = .clear
		setBackgroundColor(.white, for: .normal)
		
		placeholderLabel.textColor = placeholderColor
		placeholderLabel.backgroundColor = .clear
		placeholderLabel.font = font
		placeholderLabel.textAlignment = placeholderAlignment
		addSubview(placeholderLabel)
        
        layer.addSublayer(highlightedLayer)
		
		NotificationCenter.default.addObserver(self, selector: #selector(onTextDidChange), name: UITextView.textDidChangeNotification, object: self)
		NotificationCenter.default.addObserver(self, selector: #selector(onBeginEditing), name: UITextView.textDidBeginEditingNotification, object: self)
		NotificationCenter.default.addObserver(self, selector: #selector(onEndEditing), name: UITextView.textDidEndEditingNotification, object: self)
		
		delegate = self
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override open func draw(_ rect: CGRect) {
		super.draw(rect)
		
		let currentState: UIControl.State = isEditing ? .focused : (isEditable ? .normal : .disabled)
		let fillColor 	    = self.backgroundColor(for: currentState) ?? self.backgroundColor(for: .normal)
		let borderColor     = self.borderColor(for: currentState) ?? self.borderColor(for: .normal)
		let strokeSize	    = self.borderSize(for: currentState) ?? self.borderSize(for: .normal)
        let highlightColor  = self.highlightColor(for: currentState) ?? self.highlightColor(for: .normal)
		
		layer.backgroundColor = fillColor?.cgColor
		layer.borderColor = borderColor?.cgColor
		layer.borderWidth = strokeSize ?? 0
        
        if highlightColor != nil {
            let highlightSize           = self.highlightSize(for: currentState) ?? self.highlightSize(for: .normal) ?? 2.0
            highlightedLayer.path       = UIBezierPath(rect: CGRect(x: bounds.minX, y: bounds.maxY - highlightSize, width: bounds.width, height: highlightSize)).cgPath
            highlightedLayer.fillColor  = highlightColor!.cgColor
            highlightedLayer.isHidden   = false
        } else {
            highlightedLayer.isHidden   = true
        }
	}
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
		
		let viewSize = bounds.inset(by: placeholderInsets).size
		let contentSize = placeholderLabel.sizeThatFits(viewSize)
		placeholderLabel.frame = CGRect(x: placeholderInsets.left, y: placeholderInsets.top, width: contentSize.width, height: contentSize.height)
		
		var viewBounds = bounds
		viewBounds.origin.y = contentOffset.y
		highlightedLayer.frame = viewBounds
		CATransaction.commit()
	}
	
	// MARK: -
    
	open func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
		let key = backgroundColorKey(for: state)
		bgColorDict[key] = color
		setNeedsDisplay()
	}
	
	open func setBorderColor(_ color: UIColor?, for state: UIControl.State) {
		let key = borderColorKey(for: state)
		borderColorDict[key] = color
		setNeedsDisplay()
	}
	
	open func setBorderSize(_ value: CGFloat?, for state: UIControl.State) {
		let key = borderSizeKey(for: state)
		borderSizeDict[key] = value
		setNeedsDisplay()
	}
    
    open func setHighlightColor(_ color: UIColor?, for state: UIControl.State) {
        let key = highlightColorKey(for: state)
        highlightColorDict[key] = color
		setNeedsDisplay()
    }
    
    open func setHighlightSize(_ size: CGFloat?, for state: UIControl.State) {
        let key = highlightSizeKey(for: state)
        highlightSizeDict[key] = size
		
		setNeedsDisplay()
		setNeedsLayout()
    }
	
	// MARK: -
	
	open func backgroundColor(for state: UIControl.State) -> UIColor? {
		let key = backgroundColorKey(for: state)
		var result = bgColorDict[key]
		
		if result == nil {
			if state == .disabled {
				let normalColor = backgroundColor(for: .normal)
				result = normalColor != nil ? normalColor!.withAlphaComponent(0.3) : nil
			}
		}
		
		return result
	}
	
	open func borderColor(for state: UIControl.State) -> UIColor? {
		let key = borderColorKey(for: state)
		var result = borderColorDict[key]
		
		if result == nil {
			if state == .disabled {
				let normalColor = borderColor(for: .normal)
				result = normalColor != nil ? normalColor!.withAlphaComponent(0.3) : nil
			}
		}
		
		return result
	}
	
	open func borderSize(for state: UIControl.State) -> CGFloat? {
		let key = borderSizeKey(for: state)
		return borderSizeDict[key]
	}
	
    open func highlightColor(for state: UIControl.State) -> UIColor? {
        let key = highlightColorKey(for: state)
        var result = highlightColorDict[key]
        
        if result == nil {
            if state == .disabled {
                let normalColor = highlightColor(for: .normal)
                result = normalColor != nil ? normalColor!.withAlphaComponent(0.3) : nil
            }
        }
        
        return result
    }
    
    open func highlightSize(for state: UIControl.State) -> CGFloat? {
        let key = highlightSizeKey(for: state)
        return highlightSizeDict[key]
    }
    
	// MARK: -
	
	fileprivate func backgroundColorKey(for state: UIControl.State) -> String {
		return "bg\(state.rawValue)"
	}
	
	fileprivate func borderColorKey(for state: UIControl.State) -> String {
		return "br\(state.rawValue)"
	}
	
	fileprivate func shadowColorKey(for state: UIControl.State) -> String {
		return "sd\(state.rawValue)"
	}
	
	fileprivate func borderSizeKey(for state: UIControl.State) -> String {
		return "bs\(state.rawValue)"
	}
	
    fileprivate func highlightColorKey(for state: UIControl.State) -> String {
        return "hl\(state.rawValue)"
    }
    
    fileprivate func highlightSizeKey(for state: UIControl.State) -> String {
        return "hls\(state.rawValue)"
    }
    
	// MARK: -
	
	@objc func onBeginEditing() {
		isEditing = true
		setNeedsDisplay()
	}
	
	@objc func onEndEditing() {
		isEditing = false
		setNeedsDisplay()
	}
	
	@objc func onTextDidChange() {
		placeholderLabel.isHidden = !text.isEmpty
	}
	
	deinit {
		delegate = nil
		NotificationCenter.default.removeObserver(self)
	}
	
	fileprivate func tapped(on point: CGPoint) {
		var location: CGPoint = point
		location.x -= self.textContainerInset.left
		location.y -= self.textContainerInset.top
		let charIndex = layoutManager.characterIndex(for: location, in: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
		guard charIndex < self.textStorage.length else { return }
		
		var range = NSRange(location: 0, length: 0)
		if let attributedText = self.attributedText {
			if let link = attributedText.attribute(.link, at: charIndex, effectiveRange: &range) as? URL {
				self.didTouchedLink?(link, range, location)
			}
		}
	}
	
	open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		return maximumCharacters > 0 ? textView.text.count + (text.count - range.length) <= maximumCharacters : true
	}
	
}
