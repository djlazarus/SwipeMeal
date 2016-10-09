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
	func editProfileImageViewControllerAddImagePressed(_ controller: EditProfileImageViewController)
	func editProfileImageViewControllerSavePressed(_ controller: EditProfileImageViewController)
}

class EditProfileImageViewController: UIViewController {
	weak var delegate: EditProfileImageViewControllerDelegate?
	
	@IBOutlet fileprivate var _continueButton: UIButton!
	@IBOutlet fileprivate var _imageView: CircularImageView!
	
	override var preferredStatusBarStyle : UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		let image = UIImage(named: "user")!.withRenderingMode(.alwaysTemplate)
		
		_imageView.tintColor = UIColor(white: 0.9, alpha: 1)
		_imageView.contentMode = UIViewContentMode.scaleAspectFill
        _imageView.image = image
		
		_imageView.layer.masksToBounds = true
	}
	
	func updateImage(_ image: UIImage)
	{
		let _ = view
		DispatchQueue.main.async {
			self._imageView.image = image
		}
	}
	
	func resetImage()
	{
		guard isViewLoaded else { return }
		DispatchQueue.main.async {
			let image = UIImage(named: "user")!.withRenderingMode(.alwaysTemplate)
			self._imageView.image = image
		}
	}
	
	// MARK: - Actions
    @IBAction func _cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil);
    }
    
	@IBAction fileprivate func _addImageButtonPressed()
	{
		delegate?.editProfileImageViewControllerAddImagePressed(self)
	}
	
	@IBAction fileprivate func _saveButtonPressed()
	{
		delegate?.editProfileImageViewControllerSavePressed(self)
	}
}
