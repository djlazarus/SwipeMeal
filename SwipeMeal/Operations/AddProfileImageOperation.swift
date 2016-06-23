//
//  AddProfileImageOperation.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/22/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class AddProfileImageOperation: PresentationOperation
{
	private let _user: SwipeMealUser
	private let _alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
	private let _imagePicker = UIImagePickerController()
	
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
	
	private func _setupImagePicker()
	{
		_imagePicker.delegate = self
		_imagePicker.allowsEditing = true
	}
	
	private func _setupAlertController()
	{
		let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .Default) { (alert: UIAlertAction!) in
			self._imagePicker.sourceType = .PhotoLibrary
			self.presentViewController(self._imagePicker)
		}
		
		let takePictureAction = UIAlertAction(title: "Take Photo", style: .Default) { (alert: UIAlertAction!) in
			self._imagePicker.sourceType = .Camera
			self.presentViewController(self._imagePicker)
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert: UIAlertAction!) in
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
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
	{
		dismissViewController(picker)
		
		guard let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
			finish()
			return
		}
		
		self.profileImage = editedImage
		
		SMDatabaseLayer.upload(editedImage, forSwipeMealUser: _user) { (error, downloadURL) in
			if let url = downloadURL {
				self._user.updatePhotoURL(url, completion: { (error) in
					self.finishWithError(error)
				})
			}
			else {
				self.finishWithError(error)
			}
		}
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController)
	{
		dismissViewController(picker) {
			self.finish()
		}
	}
}
