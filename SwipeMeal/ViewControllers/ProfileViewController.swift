//
//  ProfileViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 8/15/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import FirebaseStorage
import IncipiaKit

class ProfileViewController: UIViewController {
	
	@IBOutlet private var _backgroundImageView: UIImageView!
	@IBOutlet private var _centerImageView: CircularImageView!
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_backgroundImageView.alpha = 0.5
		guard let user = SMAuthLayer.currentUser else { return }
		
		let storage = FIRStorage.storage()
		let path = "profileImages/\(user.uid).jpg"
		let pathRef = storage.referenceWithPath(path)
		pathRef.dataWithMaxSize(1024 * 1024) { (data, error) in
			
			guard let data = data else { return }
			let image = UIImage(data: data)
			self._centerImageView.image = image
			self._backgroundImageView.image = image?.applyBlur(withRadius: 4, tintColor: nil, saturationDeltaFactor: 1.2)
		}
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	// MARK: - Actions
	@IBAction private func _signOutButtonPressed() {
		SMAuthLayer.currentUser?.signOut()
	}
}
