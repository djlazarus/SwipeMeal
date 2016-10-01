//
//  NSBundle+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

public extension Bundle
{
	class public func mainInfoDictionary(key: CFString) -> String? {
		return main.infoDictionary?[key as String] as? String
	}
	
	public static var appDisplayName: String? {
		return mainInfoDictionary(key: kCFBundleNameKey)
	}
}
