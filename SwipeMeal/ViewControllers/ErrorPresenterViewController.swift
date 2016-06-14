//
//  ErrorPresenterViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class ErrorPresenterViewController: UIViewController
{
   private var _isVisible = false
   private lazy var _okAction: UIAlertAction = {
      return UIAlertAction(title: "OK", style: .Default, handler: nil)
   }()
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      view.alpha = 0
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewDidAppear(animated)
      _isVisible = true
   }
   
   override func viewWillDisappear(animated: Bool)
   {
      super.viewWillDisappear(animated)
      _isVisible = false
   }
}

extension ErrorPresenterViewController
{
   func presentStatus(status: SignUpInfoInvalidStatus)
   {
      guard _isVisible == true else { return }
      
      let alertController = UIAlertController(title: status.title, message: status.errorMessage, preferredStyle: .Alert)
      alertController.addAction(_okAction)
      presentViewController(alertController, animated: true, completion: nil)
   }
   
   func presentError(error: NSError)
   {
      guard _isVisible == true else { return }
      
      let alertController = UIAlertController(title: error.localizedDescription, message: error.localizedFailureReason, preferredStyle: .Alert)
      alertController.addAction(_okAction)
      presentViewController(alertController, animated: true, completion: nil)
   }
   
   override func presentMessage(message: String)
   {
      guard _isVisible == true else { return }
      
      let alertController = UIAlertController(title: message, message: nil, preferredStyle: .Alert)
      alertController.addAction(_okAction)
      presentViewController(alertController, animated: true, completion: nil)
   }
}
