//
//  AddProfileImageViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class AddProfileImageViewController: UIViewController
{
   @IBOutlet private var _imageView: UIImageView!
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return .LightContent
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      let image = UIImage(named: "user")!.imageWithRenderingMode(.AlwaysTemplate)
      
      _imageView.tintColor = UIColor(white: 0.9, alpha: 1)
      _imageView.image = image
   }
   
   // MARK: - Actions
   @IBAction private func _addImageButtonPressed()
   {
      let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .Default) { (alert: UIAlertAction!) in
         print("photo library")
      }
      
      let takePictureAction = UIAlertAction(title: "Take Photo", style: .Default) { (alert: UIAlertAction!) in
         print("take photo")
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert: UIAlertAction!) in
         print("cancel")
      }
    
      let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
      alertController.addAction(photoLibraryAction)
      alertController.addAction(takePictureAction)
      alertController.addAction(cancelAction)
      
      presentViewController(alertController, animated: true, completion:nil)
   }
}
