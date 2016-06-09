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
   let _signUpViewController = SignUpViewController.instantiate(.SignUp)
   
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
   func signUpViewControllerSignInButtonPressed(controller: SignUpViewController)
   {
      controller.dismissKeyboard()
      dismissViewController(controller) {
         self.finish()
      }
   }
   
   func signUpViewControllerRegisterButtonPressed(controller: SignUpViewController)
   {
      let info = SignUpInfo(controller: controller)
      let validator = SignUpInfoValidator(info: info)
      
      if let invalidStatus = validator.validate() {
         controller.present(invalidStatus)
      }
   }
}