//
//  AddProfileImageViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol AddProfileImageViewControllerDelegate: class
{
	func addProfileImageViewControllerAddImagePressed(controller: AddProfileImageViewController)
	func addProfileImageViewControllerContinuePressed(controller: AddProfileImageViewController)
}

class AddProfileImageViewController: UIViewController
{
	weak var delegate: AddProfileImageViewControllerDelegate?
	
	var continueButtonEnabled: Bool = false {
		didSet {
			guard isViewLoaded() else { return }
			dispatch_async(dispatch_get_main_queue()) {
				self._continueButton.enabled = self.continueButtonEnabled
			}
		}
	}
	
	@IBOutlet private var _continueButton: UIButton!
   @IBOutlet private var _imageView: UIImageView!
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return .LightContent
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      let image = UIImage(named: "user")!.imageWithRenderingMode(.AlwaysTemplate)
      
      _imageView.tintColor = UIColor(white: 0.9, alpha: 1)
      _imageView.image = image
		
		self._imageView.layer.cornerRadius = min(self._imageView.bounds.width, self._imageView.bounds.height) * 0.5
		self._imageView.layer.masksToBounds = true
		
		self._continueButton.enabled = self.continueButtonEnabled
   }
	
	func updateImage(image: UIImage)
	{
		dispatch_async(dispatch_get_main_queue()) {
			self._imageView.image = image
		}
	}
	
	func resetImage(image: UIImage)
	{
		dispatch_async(dispatch_get_main_queue()) {
			let image = UIImage(named: "user")!.imageWithRenderingMode(.AlwaysTemplate)
			self._imageView.image = image
		}
	}
	
   // MARK: - Actions
   @IBAction private func _addImageButtonPressed()
   {
		delegate?.addProfileImageViewControllerAddImagePressed(self)
   }
	
	@IBAction private func _continueButtonPressed()
	{
		delegate?.addProfileImageViewControllerContinuePressed(self)
	}
}
