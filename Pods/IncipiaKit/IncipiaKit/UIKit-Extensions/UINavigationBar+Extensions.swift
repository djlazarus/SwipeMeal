//
//  UINavigationBar+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 6/28/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

public extension UINavigationBar {
	public func makeTransparent() {
		setBackgroundImage(UIImage(), forBarMetrics: .Default)
	}
	
	public func resetTransparency() {
		setBackgroundImage(nil, forBarMetrics: .Default)
	}
	
	public func makeShadowTransparent() {
		shadowImage = UIImage()
	}
	
	public func resetShadowTransparency() {
		shadowImage = nil
	}
	
	public func update(backgroundColor color: UIColor) {
		let image = UIImage.imageWithColor(color)
		setBackgroundImage(image, forBarMetrics: .Default)
	}
}

public extension UIToolbar {
	public func makeTransparent() {
		setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)
	}
	
	public func resetTransparency() {
		setBackgroundImage(nil, forToolbarPosition: .Any, barMetrics: .Default)
	}
	
	public func makeShadowTransparent() {
		setShadowImage(UIImage(), forToolbarPosition: .Any)
	}
	
	public func update(backgroundColor color: UIColor) {
		let image = UIImage.imageWithColor(color)
		setBackgroundImage(image, forToolbarPosition: .Any, barMetrics: .Default)
	}
}

public extension UINavigationController {
	override public func makeNavBarTransparent() {
		navigationBar.makeTransparent()
	}
	
	override public func resetNavBarTransparency() {
		navigationBar.resetTransparency()
	}
	
	override public func makeNavBarShadowTransparent() {
		navigationBar.makeShadowTransparent()
	}
	
	public override func resetNavBarShadow() {
		navigationBar.resetShadowTransparency()
	}
	
	public override func updateNavBar(withColor color: UIColor) {
		navigationBar.update(backgroundColor: color)
	}
}
