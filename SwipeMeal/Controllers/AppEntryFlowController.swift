//
//  AppEntryFlowController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class AppEntryFlowController
{
   private let _rootNavController = UINavigationController()
   
   private let _signInViewController = SignInViewController.instantiate(.SignIn)
   private let _signUpViewController = SignUpViewController.instantiate(.SignUp)
   private let _emailVerificationController = EmailVerificationSentViewController.instantiate(.SignUp)
   
   private var _user: SwipeMealUser?
   
   let _internalQueue = NSOperationQueue()
   
   init()
   {
      _signInViewController.delegate = self
      _signUpViewController.delegate = self
      _emailVerificationController.delegate = self
      
      _emailVerificationController.modalPresentationStyle = .OverCurrentContext
      
      _rootNavController.navigationBar.barStyle = .Black
      _rootNavController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
      _rootNavController.navigationBar.shadowImage = UIImage()
      _rootNavController.pushViewController(_signInViewController, animated: false)
   }
   
   func initialViewController() -> UIViewController
   {
      return _rootNavController
   }
   
   private func _startEmailVerification(user: SwipeMealUser, presentationContext: UIViewController, sendEmail: Bool = false)
   {
      if sendEmail {
         user.sendEmailVerification({ (error) in
            if let error = error {
               presentationContext.present(error)
            }
            else {
               self._presentEmailVerificationViewController(presentationContext)
            }
         })
      }
      else {
         if user.emailVerified {
         }
         else {
            _presentEmailVerificationViewController(presentationContext)
         }
      }
   }
   
   private func _presentEmailVerificationViewController(context: UIViewController)
   {
      dispatch_async(dispatch_get_main_queue(), {
         context.presentViewController(self._emailVerificationController, animated: true, completion: nil)
      })
   }
}

extension AppEntryFlowController: SignInViewControllerDelegate
{
   func signInViewController(controller: SignInViewController, signUpButtonPressed: UIButton)
   {
      controller.presentViewController(_signUpViewController, animated: true, completion: nil)
   }
   
   func signInViewControllerSignInButtonPressed(controller: SignInViewController, email: String, password: String)
   {
      let status = AuthenticateLoginStatus(email: email, password: password)
      let authOp = AuthenticateLoginOperation(status: status)
      authOp.completionBlock = {
         
         if let error = status.error {
            controller.present(error)
         }
         else if let user = status.user {
            self._user = user
            self._startEmailVerification(user, presentationContext: controller)
         }
      }
      
      authOp.start()
   }
   
   func signInViewController(controller: SignInViewController, forgotPasswordButtonPressed: UIButton)
   {
   }
}

extension AppEntryFlowController: SignUpViewControllerDelegate
{
   func signUpViewControllerSignInButtonPressed(controller: SignUpViewController)
   {
      controller.dismissViewControllerAnimated(true, completion: nil)
   }
   
   func signUpViewControllerRegisterButtonPressed(controller: SignUpViewController)
   {
      let info = SignUpInfo(controller: controller)
      let status = CreateUserAccountStatus(info: info)
      
      let createUserAccountOp = CreateUserAccountOperation(status: status)
      createUserAccountOp.completionBlock = {
         
         if let creationError = status.error {
            controller.present(creationError)
         }
         else if let user = status.user {
            self._user = user
            self._startEmailVerification(user, presentationContext: controller, sendEmail: true)
         }
      }
      
      createUserAccountOp.start()
   }
}

extension AppEntryFlowController: EmailVerificationSentViewControllerDelegate
{
   func emailVerificationSentViewController(controller: EmailVerificationSentViewController, resendButtonPressed button: UIButton)
   {
   }
   
   func emailVerificationSentViewController(controller: EmailVerificationSentViewController, logMeInButtonPressed button: UIButton)
   {
      if let user = _user {
         user.reload({ (error) in
            if let error = error {
               controller.present(error)
            }
            else {
               if user.emailVerified {
                  print("START ONBOARDING!")
               }
               else {
                  guard let email = user.email else { return }
                  controller.presentMessage("The email address \(email) has not been verified.")
               }
            }
         })
      }
      else {
         controller.dismissViewControllerAnimated(true, completion: nil)
      }
   }
   
   func emailVerificationSentViewControllerCancelButtonPressed(controller: EmailVerificationSentViewController)
   {
      controller.dismissViewControllerAnimated(true, completion: nil)
   }
}