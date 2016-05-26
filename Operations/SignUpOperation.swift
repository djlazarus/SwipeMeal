//
//  SignInOperation.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class SignUpOperation: PresentationOperation
{
   private var _signUpViewController: SignUpViewController = {
      let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
      let controller: SignUpViewController = storyboard.instantiateInitialViewController() as! SignUpViewController
      return controller
   }()
   
   override func commonInit() {
      super.commonInit()
      _signUpViewController.delegate = self
   }
   
   override func execute() {
      presentViewController(_signUpViewController)
   }
}

extension SignUpOperation: SignUpViewControllerDelegate
{
   func signUpViewControllerSignInButtonPressed(controller: SignUpViewController) {
      dismissViewController(controller) {
         self.finish()
      }
   }
   
   func signUpViewControllerRegisterButtonPressed(controller: SignUpViewController) {
   }
}