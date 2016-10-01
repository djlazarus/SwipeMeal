//
//  AddProfileImageOperation.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/22/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import SwiftSpinner

class AddProfileImageOperation: PresentationOperation
{
	fileprivate let _user: SwipeMealUser
	fileprivate let _alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
	fileprivate let _imagePicker = UIImagePickerController()
	
	var profileImage: UIImage?
	
	init(presentationContext: UIViewController, user: SwipeMealUser)
	{
		_user = user
		super.init(presentingViewController: presentationContext)
	}
	
	override func commonInit()
	{
		_setupImagePicker()
		_setupAlertController()
	}
	
	fileprivate func _setupImagePicker()
	{
		_imagePicker.delegate = self
		_imagePicker.allowsEditing = true
	}
	
	fileprivate func _setupAlertController()
	{
		let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (alert: UIAlertAction!) in
			self._imagePicker.sourceType = .photoLibrary
			self.presentViewController(self._imagePicker)
		}
		
		let takePictureAction = UIAlertAction(title: "Take Photo", style: .default) { (alert: UIAlertAction!) in
			self._imagePicker.sourceType = .camera
			self.presentViewController(self._imagePicker)
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) in
			self.finish()
		}
		
		_alertController.addAction(photoLibraryAction)
		_alertController.addAction(takePictureAction)
		_alertController.addAction(cancelAction)
	}
	
	override func execute()
	{
		presentViewController(_alertController)
	}
}

extension AddProfileImageOperation: UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
	{
		dismissViewController(picker)
		
		guard let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
			finish()
			return
		}
		
		self.profileImage = editedImage
		
		// This is a hack and probably shouldn't live in here...
		SwiftSpinner.show("Saving Profile Image...")
		SMDatabaseLayer.upload(editedImage, forSwipeMealUser: _user) { (error, downloadURL) in
			if let url = downloadURL {
				SwiftSpinner.show("Updating Profile Image...")
				self._user.updatePhotoURL(url, completion: { (error) in
					SwiftSpinner.hide()
					self.finishWithError(error as NSError?)
				})
			}
			else {
				SwiftSpinner.hide()
				self.finishWithError(error)
			}
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
	{
		dismissViewController(picker) {
			self.finish()
		}
	}
}
