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
	func addProfileImageViewControllerAddImagePressed(_ controller: AddProfileImageViewController)
	func addProfileImageViewControllerContinuePressed(_ controller: AddProfileImageViewController)
}

class AddProfileImageViewController: UIViewController
{
	weak var delegate: AddProfileImageViewControllerDelegate?
	
	var continueButtonEnabled: Bool = false {
		didSet {
			_updateContinueButton()
		}
	}
	
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
      _imageView.image = image
		
		_imageView.layer.masksToBounds = true
		_updateContinueButton()
   }
	
	fileprivate func _updateContinueButton()
	{
		guard isViewLoaded else { return }
		DispatchQueue.main.async {
			self._continueButton.isEnabled = self.continueButtonEnabled
			self._continueButton.alpha = self.continueButtonEnabled ? 1 : 0.5
		}
	}
	
	func updateImage(_ image: UIImage)
	{
		guard isViewLoaded else { return }
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
   @IBAction fileprivate func _addImageButtonPressed()
   {
		delegate?.addProfileImageViewControllerAddImagePressed(self)
   }
	
	@IBAction fileprivate func _continueButtonPressed()
	{
		delegate?.addProfileImageViewControllerContinuePressed(self)
	}
}
