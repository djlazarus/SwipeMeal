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
   
   let _internalQueue = NSOperationQueue()
   
   init()
   {
      _signInViewController.delegate = self
      _signUpViewController.delegate = self
      
      _rootNavController.navigationBar.barStyle = .Black
      _rootNavController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
      _rootNavController.navigationBar.shadowImage = UIImage()
      _rootNavController.pushViewController(_signInViewController, animated: false)
   }
   
   func initialViewController() -> UIViewController
   {
      return _rootNavController
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
            print("AUTHENTICATED USER: \(user.email)")
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
            print("CREATED USER: \(user)")
         }
      }
      
      createUserAccountOp.start()
   }
}