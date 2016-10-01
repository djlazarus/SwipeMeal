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
   func emailVerificationSentViewController(_ controller: EmailVerificationSentViewController, resendButtonPressed button: UIButton)
   func emailVerificationSentViewController(_ controller: EmailVerificationSentViewController, logMeInButtonPressed button: UIButton)
   
   func emailVerificationSentViewControllerCancelButtonPressed(_ controller: EmailVerificationSentViewController)
}

class EmailVerificationSentViewController: UIViewController
{
   @IBOutlet fileprivate var _resendButton: SwipeMealRoundedButton!
   @IBOutlet fileprivate var _logMeInButton: SwipeMealRoundedButton!
   
   weak var delegate: EmailVerificationSentViewControllerDelegate?
   
   override var preferredStatusBarStyle : UIStatusBarStyle {
      return .lightContent
   }
   
   // MARK: - IBActions
   @IBAction fileprivate func resendButtonPressed(_ sender: UIButton)
   {
      delegate?.emailVerificationSentViewController(self, resendButtonPressed: sender)
   }
   
   @IBAction fileprivate func logMeInButtonPressed(_ sender: UIButton)
   {
      delegate?.emailVerificationSentViewController(self, logMeInButtonPressed: sender)
   }
   
   @IBAction fileprivate func cancelButtonPressed()
   {
      delegate?.emailVerificationSentViewControllerCancelButtonPressed(self)
   }
}
