//
//  EditProfileImageViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 8/15/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol EditProfileImageViewControllerDelegate: class
{
	func editProfileImageViewControllerAddImagePressed(controller: EditProfileImageViewController)
	func editProfileImageViewControllerSavePressed(controller: EditProfileImageViewController)
}

class EditProfileImageViewController: UIViewController {
	weak var delegate: EditProfileImageViewControllerDelegate?
	
	@IBOutlet private var _continueButton: UIButton!
	@IBOutlet private var _imageView: CircularImageView!
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		let image = UIImage(named: "user")!.imageWithRenderingMode(.AlwaysTemplate)
		
		_imageView.tintColor = UIColor(white: 0.9, alpha: 1)
		_imageView.image = image
		
		_imageView.layer.masksToBounds = true
	}
	
	func updateImage(image: UIImage)
	{
		let _ = view
		dispatch_async(dispatch_get_main_queue()) {
			self._imageView.image = image
		}
	}
	
	func resetImage()
	{
		guard isViewLoaded() else { return }
		dispatch_async(dispatch_get_main_queue()) {
			let image = UIImage(named: "user")!.imageWithRenderingMode(.AlwaysTemplate)
			self._imageView.image = image
		}
	}
	
	// MARK: - Actions
	@IBAction private func _addImageButtonPressed()
	{
		delegate?.editProfileImageViewControllerAddImagePressed(self)
	}
	
	@IBAction private func _saveButtonPressed()
	{
		delegate?.editProfileImageViewControllerSavePressed(self)
	}
}
