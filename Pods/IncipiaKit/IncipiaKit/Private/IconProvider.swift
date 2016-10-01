
//
//  IconProvider.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 7/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

enum IconType: String {
	case LeftArrow = "arrow-left"
	case Close = "close"
}

class IconProvider {
	static func icon(type: IconType) -> UIImage? {
		let bundle = Bundle(for: self)
		return UIImage(named: type.rawValue, in: bundle, compatibleWith: nil)
	}
}
