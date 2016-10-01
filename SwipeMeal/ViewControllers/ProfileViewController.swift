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
	
	@IBOutlet fileprivate var _nameLabel: UILabel!
	@IBOutlet fileprivate var _ratingLabel: UILabel!
	@IBOutlet fileprivate var _backgroundImageView: UIImageView!
	@IBOutlet fileprivate var _centerImageView: CircularImageView!
	@IBOutlet fileprivate var _emailLabel: UILabel!
	
	fileprivate var _profileImage: UIImage?
	
	fileprivate let _editProfileImageVC = EditProfileImageViewController.instantiate(fromStoryboard: "Main")
	fileprivate let _settingsVC = SettingsViewController.instantiate(fromStoryboard: "Main")
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_backgroundImageView.alpha = 0.5
		guard let user = SMAuthLayer.currentUser else { return }
		_syncProfileImageViews(withUser: user)
		
		_nameLabel.text = user.displayName
		_emailLabel.text = user.email
		_editProfileImageVC.delegate = self
		
		_settingsVC.modalPresentationStyle = .overCurrentContext
		_settingsVC.modalTransitionStyle = .crossDissolve
	}
	
	override var preferredStatusBarStyle : UIStatusBarStyle {
		return .lightContent
	}
	
	// MARK: - Private
	fileprivate func _syncProfileImageViews(withUser user: SwipeMealUser) {
		
		let storage = FIRStorage.storage()
		let path = "profile_images/\(user.uid).jpg"
		let pathRef = storage.reference(withPath: path)
		pathRef.data(withMaxSize: 1024 * 1024) { (data, error) in
			
			guard let data = data else { return }
			self._profileImage = UIImage(data: data)
			self._updateProfileImageViews()
		}
	}
	
	fileprivate func _updateProfileImageViews() {
		_centerImageView.image = _profileImage
		_backgroundImageView.image = _profileImage?.applyBlur(withRadius: 4, tintColor: nil, saturationDeltaFactor: 1.2)
	}
	
	// MARK: - Actions
	@IBAction fileprivate func _signOutButtonPressed() {
		SMAuthLayer.currentUser?.signOut()
	}
	
	@IBAction fileprivate func _settingsButtonPressed() {
		present(_settingsVC, animated: true, completion: nil)
	}
	
	@IBAction fileprivate func _editProfileImageButtonPressed() {
		if let image = _profileImage {
			_editProfileImageVC.updateImage(image)
		}
		tabBarController?.present(_editProfileImageVC, animated: true, completion: nil)
	}
}

extension ProfileViewController: EditProfileImageViewControllerDelegate {
	func editProfileImageViewControllerAddImagePressed(_ controller: EditProfileImageViewController) {
		
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
	
	func editProfileImageViewControllerSavePressed(_ controller: EditProfileImageViewController) {
		controller.dismiss(animated: true, completion: nil)
	}
}
