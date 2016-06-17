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
   weak var delegate: EmailVerificationSentViewControllerDelegate?
   
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
