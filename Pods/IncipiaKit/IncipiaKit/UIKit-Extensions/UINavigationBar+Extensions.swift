


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
		setBackgroundImage(UIImage(), for: .default)
	}
	
	public func resetTransparency() {
		setBackgroundImage(nil, for: .default)
	}
	
	public func makeShadowTransparent() {
		shadowImage = UIImage()
	}
	
	public func resetShadowTransparency() {
		shadowImage = nil
	}
	
	public func update(backgroundColor color: UIColor) {
		let image = UIImage.imageWithColor(color: color)
		setBackgroundImage(image, for: .default)
	}
}

public extension UIToolbar {
	public func makeTransparent() {
		setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
	}
	
	public func resetTransparency() {
		setBackgroundImage(nil, forToolbarPosition: .any, barMetrics: .default)
	}
	
	public func makeShadowTransparent() {
		setShadowImage(UIImage(), forToolbarPosition: .any)
	}
	
	public func update(backgroundColor color: UIColor) {
		let image = UIImage.imageWithColor(color: color)
		setBackgroundImage(image, forToolbarPosition: .any, barMetrics: .default)
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
