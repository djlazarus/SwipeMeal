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
}
