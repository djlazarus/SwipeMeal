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
	public static func photoAccessDeniedAlert(cancelHandler: ((UIAlertAction) -> ())? = nil) -> UIAlertController
	{
		let appName = Bundle.appDisplayName ?? "this application"
		let alertController = UIAlertController(
			title: "Photo Access Denied",
			message: "In order to add an image attachment, \(appName) needs to access your photo library.",
			preferredStyle: .alert)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler)
		alertController.addAction(cancelAction)
		
		let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
			if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
				UIApplication.shared.openURL(url as URL)
			}
		}
		alertController.addAction(openAction)
		return alertController
	}
	
	public static func microphoneAccessDeniedAlert(cancelHandler: ((UIAlertAction) -> ())? = nil) -> UIAlertController
	{
		let appName = Bundle.appDisplayName ?? "this application"
		let alertController = UIAlertController(
			title: "Microphone Access Denied",
			message: "In order to record an audio attachment, \(appName) needs to access your microphone.",
			preferredStyle: .alert)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler)
		alertController.addAction(cancelAction)
		
		let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
			if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
				UIApplication.shared.openURL(url as URL)
			}
		}
		alertController.addAction(openAction)
		return alertController
	}
}
