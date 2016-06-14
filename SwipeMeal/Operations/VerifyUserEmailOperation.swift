//
//  VerifyUserEmailOperation.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class VerifyUserEmailOperation: PresentationOperation
{
   let status: CreateUserAccountStatus
   private let _emailVerificationSentViewController = EmailVerificationSentViewController.instantiate(.SignUp)
   
   init(status: CreateUserAccountStatus, presentationContext: UIViewController)
   {
      self.status = status
      super.init(presentingViewController: presentationContext)
   }
   
   override func commonInit()
   {
      _emailVerificationSentViewController.modalPresentationStyle = .OverCurrentContext
      _emailVerificationSentViewController.delegate = self
   }
   
   override func execute()
   {
      guard status.error == nil else { finish(); return }
      presentViewController(_emailVerificationSentViewController)
   }
}

extension VerifyUserEmailOperation: EmailVerificationSentViewControllerDelegate
{
   func emailVerificationSentViewController(controller: EmailVerificationSentViewController, resendButtonPressed button: UIButton)
   {
   }
   
   func emailVerificationSentViewController(controller: EmailVerificationSentViewController, logMeInButtonPressed button: UIButton)
   {
   }
}