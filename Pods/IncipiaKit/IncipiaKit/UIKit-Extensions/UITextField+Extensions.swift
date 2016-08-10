//
//  UITextField+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

public extension UITextField {
	public func update(placeholderColor color: UIColor) {
		let placeholderText = placeholder ?? ""
		let placeholderFont = font ?? UIFont.systemFontOfSize(12)
		let placeholderAttributes = [NSFontAttributeName : placeholderFont, NSForegroundColorAttributeName : color]
		let attributedTitle = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
		attributedPlaceholder = attributedTitle
	}
}
