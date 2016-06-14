//
//  FlowController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class FlowController
{
   let _signInViewController = SignInViewController.instantiate(.SignIn)
   let _internalQueue = NSOperationQueue()
   
   init()
   {
      _signInViewController.delegate = self
   }
   
   func initialViewController() -> UIViewController
   {
      return _signInViewController
   }
}

extension FlowController: SignInViewControllerDelegate
{
   func signInViewController(controller: SignInViewController, signUpButtonPressed: UIButton)
   {
      let signUpOperation = SignUpOperation(presentingViewController: controller)
      _internalQueue.addOperation(signUpOperation)
   }
   
   func signInViewController(controller: SignInViewController, signInButtonPressed: UIButton)
   {
   }
   
   func signInViewController(controller: SignInViewController, forgotPasswordButtonPressed: UIButton)
   {
   }
}