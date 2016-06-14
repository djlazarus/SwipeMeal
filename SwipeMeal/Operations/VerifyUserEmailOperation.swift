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
      
      if let user = status.user {
         user.sendEmailVerification({ (error) in
            if let error = error {
               self.status.error = error
               self.finish()
            }
            else {
               self.presentViewController(self._emailVerificationSentViewController)
            }
         })
      }
      else {
         status.error = SwipeMealErrors.User.currentUserIsNil
         finish()
         
      }
   }
}

extension VerifyUserEmailOperation: EmailVerificationSentViewControllerDelegate
{
   func emailVerificationSentViewController(controller: EmailVerificationSentViewController, resendButtonPressed button: UIButton)
   {
      guard let user = status.user else { return }
      user.sendEmailVerification { (error) in
         if let error = error {
            controller.present(error)
         }
         else {
            controller.presentMessage("Email verification has been sent")
         }
      }
   }
   
   func emailVerificationSentViewController(controller: EmailVerificationSentViewController, logMeInButtonPressed button: UIButton)
   {
      guard let user = status.user else { return }
      user.reload { (error) in
         if let error = error {
            controller.present(error)
         }
         else {
            if user.emailVerified {
               self.finish()
            }
            else {
               let error = SwipeMealErrors.User.emailNotVerified
               controller.present(error)
            }
         }
      }
   }
}