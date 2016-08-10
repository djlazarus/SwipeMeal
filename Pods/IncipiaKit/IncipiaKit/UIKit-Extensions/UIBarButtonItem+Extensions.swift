//
//  UIBarButtonItem+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 7/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
	public static func back(target target: AnyObject? = nil, action: Selector? = nil) -> UIBarButtonItem {
		let backImage = IconProvider.icon(.LeftArrow)
		
		let overriddenTarget = action != nil ? target : nil
		let overriddenAction = action ?? #selector(UIBarButtonItem.ik_doNothing)
		
		return UIBarButtonItem(image: backImage, style: .Plain, target: overriddenTarget, action: overriddenAction)
	}
	
	public static var empty: UIBarButtonItem {
		return UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
	}
	
	public func update(color color: UIColor) {
		tintColor = color
		if var attributes = titleTextAttributesForState(.Normal) {
			attributes[NSForegroundColorAttributeName] = color
		} else {
			setTitleTextAttributes([NSForegroundColorAttributeName : color], forState: .Normal)
		}
		
		let highlightedColor = color.colorWithAlphaComponent(0.4)
		if var attributes = titleTextAttributesForState(.Highlighted) {
			attributes[NSForegroundColorAttributeName] = highlightedColor
		} else {
			setTitleTextAttributes([NSForegroundColorAttributeName : highlightedColor], forState: .Highlighted)
		}
	}
	
	@objc private func ik_doNothing() {}
}