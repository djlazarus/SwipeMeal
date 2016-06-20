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
      let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
      
      let photoLibraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) in
         print("photo library")
      })
      
      let takePictureAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) in
         print("take photo")
      })
      
      let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in
         print("cancel")
      })
      
      alertController.addAction(photoLibraryAction)
      alertController.addAction(takePictureAction)
      alertController.addAction(cancelAction)
      
      self.presentViewController(alertController, animated: true, completion:{})
   }
}
