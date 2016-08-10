//
//  NSBundle+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

public extension NSBundle
{
	class public func mainInfoDictionary(key: CFString) -> String? {
		return mainBundle().infoDictionary?[key as String] as? String
	}
	
	public static var appDisplayName: String? {
		return mainInfoDictionary(kCFBundleNameKey)
	}
}