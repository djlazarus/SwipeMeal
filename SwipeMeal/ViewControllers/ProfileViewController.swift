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
	
	@IBOutlet private var _nameLabel: UILabel!
	@IBOutlet private var _ratingLabel: UILabel!
	@IBOutlet private var _backgroundImageView: UIImageView!
	@IBOutlet private var _centerImageView: CircularImageView!
	@IBOutlet private var _emailLabel: UILabel!
	
	private var _profileImage: UIImage?
	
	private let _editProfileImageVC = EditProfileImageViewController.instantiate(fromStoryboard: "Main")
	private let _settingsVC = SettingsViewController.instantiate(fromStoryboard: "Main")
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_backgroundImageView.alpha = 0.5
		guard let user = SMAuthLayer.currentUser else { return }
		_syncProfileImageViews(withUser: user)
		
		_nameLabel.text = user.displayName
		_emailLabel.text = user.email
		_editProfileImageVC.delegate = self
		
		_settingsVC.modalPresentationStyle = .OverCurrentContext
		_settingsVC.modalTransitionStyle = .CrossDissolve
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	// MARK: - Private
	private func _syncProfileImageViews(withUser user: SwipeMealUser) {
		
		let storage = FIRStorage.storage()
		let path = "profile_images/\(user.uid).jpg"
		let pathRef = storage.referenceWithPath(path)
		pathRef.dataWithMaxSize(1024 * 1024) { (data, error) in
			
			guard let data = data else { return }
			self._profileImage = UIImage(data: data)
			self._updateProfileImageViews()
		}
	}
	
	private func _updateProfileImageViews() {
		_centerImageView.image = _profileImage
		_backgroundImageView.image = _profileImage?.applyBlur(withRadius: 4, tintColor: nil, saturationDeltaFactor: 1.2)
	}
	
	// MARK: - Actions
	@IBAction private func _signOutButtonPressed() {
		SMAuthLayer.currentUser?.signOut()
	}
	
	@IBAction private func _settingsButtonPressed() {
		presentViewController(_settingsVC, animated: true, completion: nil)
	}
	
	@IBAction private func _editProfileImageButtonPressed() {
		if let image = _profileImage {
			_editProfileImageVC.updateImage(image)
		}
		tabBarController?.presentViewController(_editProfileImageVC, animated: true, completion: nil)
	}
}

extension ProfileViewController: EditProfileImageViewControllerDelegate {
	func editProfileImageViewControllerAddImagePressed(controller: EditProfileImageViewController) {
		
		guard let user = SMAuthLayer.currentUser else { return }
		
		let addProfileImageOp = AddProfileImageOperation(presentationContext: controller, user: user)
		addProfileImageOp.completionBlock = {
			if let image = addProfileImageOp.profileImage {
				controller.updateImage(image)
				self._profileImage = image
				self._updateProfileImageViews()
			}
		}
		
		addProfileImageOp.start()
	}
	
	func editProfileImageViewControllerSavePressed(controller: EditProfileImageViewController) {
		controller.dismissViewControllerAnimated(true, completion: nil)
	}
}
