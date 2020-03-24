//
//  NKTextField.swift
//  NKComponents
//
//  Created by Nam Kennic on 8/17/17.
//  Copyright © 2017 Nam Kennic. All rights reserved.
//

import UIKit

extension UIControl.State {
	static let error = UIControl.State(rawValue: 1 << 16)
}

extension UITextField {
	
	open func setRightImage(image: UIImage?) {
		guard let image = image else {
			rightView = nil
			return
		}
		
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFit
		rightView = imageView
		rightViewMode = .always
	}
	
	open func setLeftImage(image: UIImage?) {
		guard let image = image else {
			leftView = nil
			return
		}
		
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFit
		leftView = imageView
		leftViewMode = .always
	}
	
}

open class NKTextField: UITextField {
	
	public var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			if layer.cornerRadius != newValue {
				layer.cornerRadius = newValue
				setNeedsDisplay()
			}
		}
	}
	
	/** Shadow radius */
	public var shadowRadius: CGFloat = 0 {
		didSet {
			if shadowRadius != oldValue {
				setNeedsDisplay()
			}
		}
	}
	
	/** Shadow opacity */
	public var shadowOpacity: Float = 0.5 {
		didSet {
			if shadowOpacity != oldValue {
				setNeedsDisplay()
			}
		}
	}
	
	/** Shadow offset */
	public var shadowOffset: CGSize = .zero {
		didSet {
			if shadowOffset != oldValue {
				setNeedsDisplay()
			}
		}
	}
	
	/** Size of border */
	public var borderSize: CGFloat = 0 {
		didSet {
			if borderSize != oldValue {
				setNeedsDisplay()
			}
		}
	}
	
	/** Rounds both sides of the button */
	public var roundedTextField: Bool = false {
		didSet {
			if roundedTextField != oldValue {
				setNeedsLayout()
			}
		}
	}
	
	/** If `true`, disabled color will be set from normal color with tranparency */
	public var autoSetDisableColor: Bool = false
    
	/** Content EdgeInsets */
	public var contentEdgeInsets: UIEdgeInsets = .zero
	
	public var leftPadding: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	
	public var rightPadding: CGFloat = 10 {
		didSet {
			setNeedsLayout()
		}
	}
	
	public var leftViewEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) {
		didSet {
			setNeedsLayout()
		}
	}
	
	public var rightViewEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10) {
		didSet {
			setNeedsLayout()
		}
	}
	
	override open var isSecureTextEntry: Bool {
		set {
			super.isSecureTextEntry = newValue
			fixCaretPosition()
		}
		get {
			return super.isSecureTextEntry
		}
	}
	
	var isError: Bool = false {
		didSet {
			if isError {
				showError()
			}
			else {
				hideError()
			}
		}
	}
	
	var errorColor: UIColor! = UIColor(red:1.0, green:0.164, blue:0.138, alpha:1.00)
	var placeholderColor: UIColor? = nil {
		didSet {
			setNeedsDisplay()
		}
	}
    
    var placeholderFont: UIFont? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
	
	override public var placeholder: String? {
		didSet {
            if let color = placeholderColor, let placeholder = placeholder, let placeholderFont = placeholderFont ?? font {
                attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: placeholderFont])
			}
			else {
				super.placeholder = placeholder
			}
		}
	}
    
	fileprivate let shadowLayer 		= CAShapeLayer()
	fileprivate let backgroundLayer 	= CAShapeLayer()
    fileprivate let highlightedLayer 	= CAShapeLayer()
	fileprivate var bgColorDict			: [String: UIColor] = [:]
	fileprivate var borderColorDict		: [String: UIColor] = [:]
	fileprivate var shadowColorDict		: [String: UIColor] = [:]
	fileprivate var highlightColorDict	: [String: UIColor] = [:]
	fileprivate var highlightSizeDict	: [String: CGFloat] = [:]
	
	convenience public init(placeholder: String? = nil, icon: UIImage? = nil) {
		self.init()
		
		self.placeholder = placeholder
		leftView = icon != nil ? UIImageView(image: icon) : nil
		leftViewMode = icon != nil ? .always : .never
	}
	
	public init() {
		super.init(frame: .zero)
		
		keyboardAppearance = .light
		textAlignment = .left
		contentVerticalAlignment = .center
		contentHorizontalAlignment = .center
		textColor = .black
		clearButtonMode = .whileEditing
		tintColor = .gray
		
		placeholderColor = UIColor(white: 0.8, alpha: 1.0)
		borderSize = 0.0
		roundedTextField = false
		
		layer.addSublayer(shadowLayer)
		layer.addSublayer(backgroundLayer)
        layer.addSublayer(highlightedLayer)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override open func draw(_ rect: CGRect) {
		super.draw(rect)
		
		let currentState: UIControl.State = isError ? .error : isFirstResponder ? .focused : state
		let fillColor 	 	= self.backgroundColor(for: currentState) ?? self.backgroundColor(for: .normal)
		let borderColor  	= self.borderColor(for: currentState) ?? self.borderColor(for: .normal)
		let shadowColor	 	= self.shadowColor(for: currentState) ?? self.shadowColor(for: .normal)
		let highlightColor	= self.highlightColor(for: currentState) ?? self.highlightColor(for: .normal)
		let path			= UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
		
		backgroundLayer.path			= path.cgPath
		backgroundLayer.fillColor		= fillColor?.cgColor
		backgroundLayer.strokeColor		= borderColor?.cgColor
		backgroundLayer.lineWidth		= borderSize
		backgroundLayer.miterLimit		= path.miterLimit
		
        if highlightColor != nil {
			let highlightSize			= self.highlightSize(for: currentState) ?? self.highlightSize(for: .normal) ?? 2.0
			highlightedLayer.path 		= UIBezierPath(rect: CGRect(x: bounds.minX, y: bounds.maxY - highlightSize, width: bounds.width, height: highlightSize)).cgPath
            highlightedLayer.fillColor 	= highlightColor!.cgColor
            highlightedLayer.isHidden 	= false
        } else {
            highlightedLayer.isHidden 	= true
        }
        
		if shadowColor != nil {
			shadowLayer.isHidden 		= false
			shadowLayer.path 			= path.cgPath
			shadowLayer.shadowPath 		= path.cgPath
			shadowLayer.fillColor 		= shadowColor!.cgColor
			shadowLayer.shadowColor 	= shadowColor!.cgColor
			shadowLayer.shadowRadius 	= shadowRadius
			shadowLayer.shadowOpacity 	= shadowOpacity
			shadowLayer.shadowOffset 	= shadowOffset
		}
		else {
			shadowLayer.isHidden = true
		}
	}
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		
		shadowLayer.frame = bounds
		backgroundLayer.frame = bounds
        highlightedLayer.frame = bounds
		
		if roundedTextField {
			layer.cornerRadius = bounds.size.height/2
			setNeedsDisplay()
		}
	}
	
	// MARK: -
	
	@discardableResult
	override open func becomeFirstResponder() -> Bool {
		hideError()
		setNeedsDisplay()
		return super.becomeFirstResponder()
	}
	
	@discardableResult
	override open func resignFirstResponder() -> Bool {
		setNeedsDisplay()
		return super.resignFirstResponder()
	}
	
	// MARK: -
	
	override open var frame: CGRect {
		get {
			return super.frame
		}
		set {
			let sizeChanged = super.frame.size != newValue.size
			super.frame = newValue
			
			if sizeChanged {
				setNeedsDisplay()
				setNeedsLayout()
			}
		}
	}
	
	override open var bounds: CGRect {
		get {
			return super.bounds
		}
		set {
			let sizeChanged = super.bounds.size != newValue.size
			super.bounds = newValue
			
			if sizeChanged {
				setNeedsDisplay()
				setNeedsLayout()
			}
		}
	}
	
	// MARK: -
	
	public func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
		let key = backgroundColorKey(for: state)
		bgColorDict[key] = color
	}
	
	public func setBorderColor(_ color: UIColor?, for state: UIControl.State) {
		let key = borderColorKey(for: state)
		borderColorDict[key] = color
	}
	
	public func setShadowColor(_ color: UIColor?, for state: UIControl.State) {
		let key = shadowColorKey(for: state)
		shadowColorDict[key] = color
	}
	
	public func setHighlightColor(_ color: UIColor?, for state: UIControl.State) {
		let key = highlightColorKey(for: state)
		highlightColorDict[key] = color
	}
	
	public func setHighlightSize(_ size: CGFloat?, for state: UIControl.State) {
		let key = highlightSizeKey(for: state)
		highlightSizeDict[key] = size
	}
	
	public func backgroundColor(for state: UIControl.State) -> UIColor? {
		let key = backgroundColorKey(for: state)
		var result = bgColorDict[key]
		
		if result == nil {
			if state == .disabled && autoSetDisableColor {
				let normalColor = backgroundColor(for: .normal)
				result = normalColor != nil ? normalColor!.withAlphaComponent(0.3) : nil
			}
		}
		
		return result
	}
	
	public func borderColor(for state: UIControl.State) -> UIColor? {
		let key = borderColorKey(for: state)
		var result = borderColorDict[key]
		
		if result == nil {
			if state == .disabled && autoSetDisableColor {
				let normalColor = borderColor(for: .normal)
				result = normalColor != nil ? normalColor!.withAlphaComponent(0.3) : nil
			}
		}
		
		return result
	}
	
	public func shadowColor(for state: UIControl.State) -> UIColor? {
		let key = shadowColorKey(for: state)
		return shadowColorDict[key]
	}
	
	public func highlightColor(for state: UIControl.State) -> UIColor? {
		let key = highlightColorKey(for: state)
		var result = highlightColorDict[key]
		
		if result == nil {
			if state == .disabled && autoSetDisableColor {
				let normalColor = highlightColor(for: .normal)
				result = normalColor != nil ? normalColor!.withAlphaComponent(0.3) : nil
			}
		}
		
		return result
	}
	
	public func highlightSize(for state: UIControl.State) -> CGFloat? {
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
	
	fileprivate func highlightColorKey(for state: UIControl.State) -> String {
		return "hl\(state.rawValue)"
	}
	
	fileprivate func highlightSizeKey(for state: UIControl.State) -> String {
		return "hls\(state.rawValue)"
	}
	
	// MARK: -
	
	func contentRect(forBounds bounds: CGRect) -> CGRect {
		let corner2 = cornerRadius/2
		var edgeInsets = contentEdgeInsets
		edgeInsets.left  += leftViewRect(forBounds: bounds).maxX + corner2
		edgeInsets.right += rightViewRect(forBounds: bounds).size.width + corner2
		edgeInsets.left  += leftPadding
		edgeInsets.right += rightPadding
		
		return bounds.inset(by: edgeInsets)
	}
	
	override open func editingRect(forBounds bounds: CGRect) -> CGRect {
		return contentRect(forBounds: bounds)
	}
	
	override open func textRect(forBounds bounds: CGRect) -> CGRect {
		return contentRect(forBounds: bounds)
	}
	
	override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return contentRect(forBounds: bounds)
	}
	
	override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
		guard leftView != nil else {
			return super.leftViewRect(forBounds: bounds)
		}
		
		var result = super.leftViewRect(forBounds: bounds)
		result.origin.x += leftViewEdgeInsets.left
		result.origin.y += leftViewEdgeInsets.top
		result.size.width += leftViewEdgeInsets.right
		result.size.height += leftViewEdgeInsets.bottom
		return result
	}
	
	override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
		guard rightView != nil else {
			return super.rightViewRect(forBounds: bounds)
		}
		
		var result = super.rightViewRect(forBounds: bounds)
		let rectW = rightViewEdgeInsets.left + rightViewEdgeInsets.right
		let rectH = rightViewEdgeInsets.top + rightViewEdgeInsets.bottom
		result.origin.x -= rectW
		result.origin.y -= rectH
//		result.size.width += rectW
//		result.size.height += rectH
		return result
	}
	
	// MARK: -
	
	func showError() {
		let animation = CABasicAnimation(keyPath: "fillColor")
		
		animation.fromValue = errorColor.cgColor
		animation.toValue = backgroundLayer.fillColor
		animation.duration = 0.2
		animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
		animation.fillMode = .forwards
		animation.isRemovedOnCompletion = false
		animation.repeatCount = 2
		
		backgroundLayer.add(animation, forKey: animation.keyPath)
		setNeedsDisplay()
	}
	
	func hideError() {
		backgroundLayer.removeAllAnimations()
		setNeedsDisplay()
	}
	
}

extension UITextField {
	/// Moves the caret to the correct position by removing the trailing whitespace
	func fixCaretPosition() {
		// Moving the caret to the correct position by removing the trailing whitespace
		// http://stackoverflow.com/questions/14220187/uitextfield-has-trailing-whitespace-after-securetextentry-toggle
		
		let beginning = beginningOfDocument
		selectedTextRange = textRange(from: beginning, to: beginning)
		let end = endOfDocument
		selectedTextRange = textRange(from: end, to: end)
	}
}
