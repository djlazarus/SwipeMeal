//
//  AppEntryFlowController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import SwiftSpinner
import FirebaseAuth

class AppEntryFlowController
{
   private let _rootNavController = SwipeMealNavigationController()
   
   private let _signInViewController = SignInViewController.instantiate(.SignIn)
   private let _signUpViewController = SignUpViewController.instantiate(.SignUp)
   private let _emailVerificationController = EmailVerificationSentViewController.instantiate(.SignUp)
   
   private let _welcomeViewController = WelcomeViewController.instantiate(.Onboarding)
   private let _profileImageViewController = AddProfileImageViewController.instantiate(.Onboarding)
   
	private var _user: SwipeMealUser?
	private let _operationQueue = NSOperationQueue()
   
   init() {
      _signInViewController.delegate = self
      _signUpViewController.delegate = self
      _emailVerificationController.delegate = self
      _welcomeViewController.delegate = self
		_profileImageViewController.delegate = self
		
      _emailVerificationController.modalPresentationStyle = .OverCurrentContext
      _rootNavController.pushViewController(_signInViewController, animated: false)
   }
   
   func initialViewController() -> UIViewController {
		if let user = SMAuthLayer.currentUser {
			_user = user
			if !user.emailVerified {
				_presentEmailVerificationViewController(_signInViewController)
			} else if !user.profileSetupComplete {
				_rootNavController.pushViewController(_welcomeViewController, animated: false)
			} else {
				let sb = UIStoryboard(name: "Main", bundle: nil)
				if let initialController = sb.instantiateInitialViewController() {
					_rootNavController.setNavigationBarHidden(true, animated: false)
					_rootNavController.viewControllers = [_signInViewController, initialController]
				}
			}
		}
		
		FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth, user) in
			if user == nil {
				self._rootNavController.setNavigationBarHidden(false, animated: true)
				self._rootNavController.popToRootViewControllerAnimated(true)
			}
		})
		
      return _rootNavController
   }
   
   private func _startEmailVerification(user: SwipeMealUser, presentationContext: UIViewController, sendEmail: Bool = false) {
      if sendEmail {
			SwiftSpinner.show("Sending Verification Email...")
         user.sendEmailVerification({ (error) in
				
				SwiftSpinner.hide()
            if let error = error {
               presentationContext.present(error)
            } else {
               self._presentEmailVerificationViewController(presentationContext)
            }
         })
      } else {
         if user.emailVerified {
         } else {
            _presentEmailVerificationViewController(presentationContext)
         }
      }
   }
   
   private func _startProfileSetup(user: SwipeMealUser, fromSignUp: Bool = false) {
      dispatch_async(dispatch_get_main_queue()) {
         if fromSignUp {
            self._rootNavController.pushViewController(self._welcomeViewController, animated: false)
            self._signUpViewController.dismissViewControllerAnimated(true, completion: nil)
         } else {
            self._rootNavController.pushViewController(self._welcomeViewController, animated: true)
         }
      }
   }
   
   private func _presentEmailVerificationViewController(context: UIViewController) {
      dispatch_async(dispatch_get_main_queue(), {
         context.presentViewController(self._emailVerificationController, animated: true, completion: nil)
      })
   }
}

// MARK: - SignInViewControllerDelegate
extension AppEntryFlowController: SignInViewControllerDelegate {
	
   func signInViewController(controller: SignInViewController, signUpButtonPressed: UIButton) {
      _rootNavController.presentViewController(_signUpViewController, animated: true, completion: nil)
   }
   
   func signInViewControllerSignInButtonPressed(controller: SignInViewController, email: String, password: String) {
		SwiftSpinner.show("Signing In...")
		
      let status = AuthenticateLoginStatus(email: email, password: password)
      let authOp = AuthenticateLoginOperation(status: status)
      authOp.completionBlock = {
			
			SwiftSpinner.hide()
         if let error = status.error {
            controller.present(error)
         }
         
         guard let user = status.user else { return }
         self._user = user
         
         if !user.emailVerified {
            self._startEmailVerification(user, presentationContext: controller)
         } else if !user.profileSetupComplete {
            self._startProfileSetup(user)
         } else {
				self._showHomeScreen()
         }
      }
		
      authOp.start()
   }
   
   func signInViewController(controller: SignInViewController, forgotPasswordButtonPressed: UIButton) {
   }
}

// MARK: - SignUpViewControllerDelegate
extension AppEntryFlowController: SignUpViewControllerDelegate
{
   func signUpViewControllerSignInButtonPressed(controller: SignUpViewController) {
      controller.dismissViewControllerAnimated(true, completion: nil)
   }
   
   func signUpViewControllerRegisterButtonPressed(controller: SignUpViewController) {
      let info = SignUpInfo(controller: controller)
      let status = CreateUserAccountStatus(info: info)
		
		SwiftSpinner.show("Creating Account...")
      let createUserAccountOp = CreateUserAccountOperation(status: status)
		
		let updateProfileInfoOp = NSBlockOperation {
			if status.error != nil {
				return
			}
			
			guard let user = status.user else { return }
			user.updateDisplayName("\(info.firstName) \(info.lastName)", completion: { (error) in
				status.error = error
			})
		}
		
		let startEmailVerificationOp = NSBlockOperation {
			if let error = status.error {
				SwiftSpinner.hide()
				controller.present(error)
				return
			}
			
			SwiftSpinner.hide()
			
			guard let user = status.user else { return }
			self._user = user
			dispatch_async(dispatch_get_main_queue()) {
				self._startEmailVerification(user, presentationContext: controller, sendEmail: true)
			}
		}
		
		updateProfileInfoOp.addDependency(createUserAccountOp)
		startEmailVerificationOp.addDependency(updateProfileInfoOp)
		
		let ops = [createUserAccountOp, updateProfileInfoOp, startEmailVerificationOp]
		_operationQueue.addOperations(ops, waitUntilFinished: false)
   }
}

// MARK: - EmailVerificationSentViewControllerDelegate
extension AppEntryFlowController: EmailVerificationSentViewControllerDelegate
{
   func emailVerificationSentViewController(controller: EmailVerificationSentViewController, resendButtonPressed button: UIButton) {
      if let user = _user {
			SwiftSpinner.show("Resending Verification Email...")
         user.sendEmailVerification({ (error) in
				
				SwiftSpinner.hide() {
					controller.presentMessage("Verification email sent.")
				}
         })
      }
   }
   
   func emailVerificationSentViewController(controller: EmailVerificationSentViewController, logMeInButtonPressed button: UIButton) {
      guard let user = _user else {
         controller.dismissViewControllerAnimated(true, completion: nil)
         return
      }
		
		SwiftSpinner.show("Checking email")
      user.reload({ (error) in
			
			SwiftSpinner.hide()
         if let error = error {
            controller.present(error)
         } else {
            if user.emailVerified {
               controller.dismissViewControllerAnimated(true, completion: {
                  self._startProfileSetup(user, fromSignUp: true)
               })
            } else {
               guard let email = user.email else { return }
               controller.presentMessage("The email address \(email) has not been verified.")
            }
         }
      })
   }
   
   func emailVerificationSentViewControllerCancelButtonPressed(controller: EmailVerificationSentViewController) {
      controller.dismissViewControllerAnimated(true, completion: nil)
   }
}

// MARK: - WelcomeViewControllerDelegate
extension AppEntryFlowController: WelcomeViewControllerDelegate {
	
   func welcomeViewControllerShouldFinish(controller: WelcomeViewController)
	{
		_profileImageViewController.resetImage()
		_profileImageViewController.continueButtonEnabled = false
      _rootNavController.pushViewController(_profileImageViewController, animated: true)
   }
}

// MARK: - AddProfileImageViewControllerDelegate
extension AppEntryFlowController: AddProfileImageViewControllerDelegate {
	
	func addProfileImageViewControllerAddImagePressed(controller: AddProfileImageViewController) {
		guard let user = _user else { return }
		
		let addProfileImageOp = AddProfileImageOperation(presentationContext: controller, user: user)
		addProfileImageOp.completionBlock = {
			
			if let image = addProfileImageOp.profileImage {
				controller.updateImage(image)
				controller.continueButtonEnabled = true
			} else {
				controller.continueButtonEnabled = false
			}
		}
		
		addProfileImageOp.start()
	}
	
	func addProfileImageViewControllerContinuePressed(controller: AddProfileImageViewController) {
		guard let user = _user else { return }
		SMDatabaseLayer.setProfileSetupComplete(true, forUser: user)
		SMDatabaseLayer.addUserToRespectiveGroup(user)
		
		_showHomeScreen()
	}
	
	private func _showHomeScreen(animated animated: Bool = true) {
		dispatch_async(dispatch_get_main_queue()) {
			let sb = UIStoryboard(name: "Main", bundle: nil)
			guard let initialController = sb.instantiateInitialViewController() else { return }
			self._rootNavController.setNavigationBarHidden(true, animated: animated)
			self._rootNavController.pushViewController(initialController, animated: animated)
		}
	}
}