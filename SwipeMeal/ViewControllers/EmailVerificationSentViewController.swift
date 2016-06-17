//
//  EmailVerificationSentViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol EmailVerificationSentViewControllerDelegate: class
{
   func emailVerificationSentViewController(controller: EmailVerificationSentViewController, resendButtonPressed button: UIButton)
   func emailVerificationSentViewController(controller: EmailVerificationSentViewController, logMeInButtonPressed button: UIButton)
   
   func emailVerificationSentViewControllerCancelButtonPressed(controller: EmailVerificationSentViewController)
}

class EmailVerificationSentViewController: UIViewController
{
   @IBOutlet private var _resendButton: UIButton!
   @IBOutlet private var _logMeInButton: UIButton!
   
   weak var delegate: EmailVerificationSentViewControllerDelegate?
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      _resendButton.layer.cornerRadius = 4
      _logMeInButton.layer.cornerRadius = 4
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return .LightContent
   }
   
   // MARK: - IBActions
   @IBAction private func resendButtonPressed(sender: UIButton)
   {
      delegate?.emailVerificationSentViewController(self, resendButtonPressed: sender)
   }
   
   @IBAction private func logMeInButtonPressed(sender: UIButton)
   {
      delegate?.emailVerificationSentViewController(self, logMeInButtonPressed: sender)
   }
   
   @IBAction private func cancelButtonPressed()
   {
      delegate?.emailVerificationSentViewControllerCancelButtonPressed(self)
   }
}
