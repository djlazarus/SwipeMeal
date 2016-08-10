//
//  UIAlertController+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 6/28/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

public extension UIAlertController
{
	public static func photoAccessAlert(cancelHandler: ((UIAlertAction) -> ())? = nil) -> UIAlertController
	{
		let appName = NSBundle.appDisplayName ?? "this application"
		let alertController = UIAlertController(
			title: "Photo Access Denied",
			message: "In order to add an image attachment, \(appName) needs to access your photo library.",
			preferredStyle: .Alert)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelHandler)
		alertController.addAction(cancelAction)
		
		let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
			if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
				UIApplication.sharedApplication().openURL(url)
			}
		}
		alertController.addAction(openAction)
		return alertController
	}
	
	public static func microphoneAccessAlert(cancelHandler: ((UIAlertAction) -> ())? = nil) -> UIAlertController
	{
		let appName = NSBundle.appDisplayName ?? "this application"
		let alertController = UIAlertController(
			title: "Microphone Access Denied",
			message: "In order to record an audio attachment, \(appName) needs to access your microphone.",
			preferredStyle: .Alert)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelHandler)
		alertController.addAction(cancelAction)
		
		let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
			if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
				UIApplication.sharedApplication().openURL(url)
			}
		}
		alertController.addAction(openAction)
		return alertController
	}
}
