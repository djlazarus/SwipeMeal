//
//  SignUpViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol SignUpViewControllerDelegate: class
{
   func signUpViewControllerSignInButtonPressed(controller: SignUpViewController)
   func signUpViewControllerRegisterButtonPressed(controller: SignUpViewController)
}

class SignUpViewController: UIViewController
{
   weak var delegate: SignUpViewControllerDelegate?
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return .LightContent
   }
   
   // MARK: - Actions
   @IBAction private func _signInButtonPressed()
   {
      delegate?.signUpViewControllerSignInButtonPressed(self)
   }
}
