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
import IncipiaKit
import OneSignal

class AppEntryFlowController
{
   fileprivate let _rootNavController = SwipeMealNavigationController()
   
   fileprivate let _signInViewController = SignInViewController.instantiate(.SignIn)
   fileprivate let _signUpViewController = SignUpViewController.instantiate(.SignUp)
   fileprivate let _emailVerificationController = EmailVerificationSentViewController.instantiate(.SignUp)
   
   fileprivate let _welcomeViewController = WelcomeViewController.instantiate(.Onboarding)
   fileprivate let _profileImageViewController = AddProfileImageViewController.instantiate(.Onboarding)
   
	fileprivate var _user: SwipeMealUser?
	fileprivate let _operationQueue = OperationQueue()
   
   init() {
      _signInViewController.delegate = self
      _signUpViewController.delegate = self
      _emailVerificationController.delegate = self
      _welcomeViewController.delegate = self
		_profileImageViewController.delegate = self
		
      _emailVerificationController.modalPresentationStyle = .overCurrentContext
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
			
			OneSignal.idsAvailable({ (playerID, apnsToken) in
				if playerID != nil {
					SwipeMealPushStorage.oneSignalPlayerID = playerID
					SMDatabaseLayer.update(oneSignalPlayerID: playerID!, forUser: user)
				}
				if apnsToken != nil {
					SwipeMealPushStorage.deviceToken = apnsToken
					SMDatabaseLayer.update(deviceToken: apnsToken!, forUser: user)
				}
			})
		}
		
		FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
			if user == nil {
				self._rootNavController.setNavigationBarHidden(false, animated: true)
				self._rootNavController.popToRootViewController(animated: true)
			}
		})
		
      return _rootNavController
   }
   
   fileprivate func _startEmailVerification(_ user: SwipeMealUser, presentationContext: UIViewController, sendEmail: Bool = false) {
      if sendEmail {
			SwiftSpinner.show("Sending Verification Email...")
         user.sendEmailVerification({ (error) in
				
				SwiftSpinner.hide()
            if let error = error {
               presentationContext.present(error: error as NSError)
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
   
   fileprivate func _startProfileSetup(_ user: SwipeMealUser, fromSignUp: Bool = false) {
      DispatchQueue.main.async {
         if fromSignUp {
            self._rootNavController.pushViewController(self._welcomeViewController, animated: false)
            self._signUpViewController.dismiss(animated: true, completion: nil)
         } else {
            self._rootNavController.pushViewController(self._welcomeViewController, animated: true)
         }
      }
   }
   
   fileprivate func _presentEmailVerificationViewController(_ context: UIViewController) {
      DispatchQueue.main.async(execute: {
         context.present(self._emailVerificationController, animated: true, completion: nil)
      })
   }
}

// MARK: - SignInViewControllerDelegate
extension AppEntryFlowController: SignInViewControllerDelegate {
	
   func signInViewController(_ controller: SignInViewController, signUpButtonPressed: UIButton) {
      _rootNavController.present(_signUpViewController, animated: true, completion: nil)
   }
   
   func signInViewControllerSignInButtonPressed(_ controller: SignInViewController, email: String, password: String) {
		SwiftSpinner.show("Signing In...")
		
      let status = AuthenticateLoginStatus(email: email, password: password)
      let authOp = AuthenticateLoginOperation(status: status)
      authOp.completionBlock = {
			
			SwiftSpinner.hide()
         if let error = status.error {
            controller.present(error: error as NSError)
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
   
   func signInViewController(_ controller: SignInViewController, forgotPasswordButtonPressed: UIButton) {
   }
}

// MARK: - SignUpViewControllerDelegate
extension AppEntryFlowController: SignUpViewControllerDelegate
{
   func signUpViewControllerSignInButtonPressed(_ controller: SignUpViewController) {
      controller.dismiss(animated: true, completion: nil)
   }
   
   func signUpViewControllerRegisterButtonPressed(_ controller: SignUpViewController) {
      let info = SignUpInfo(controller: controller)
      let status = CreateUserAccountStatus(info: info)
		
		SwiftSpinner.show("Creating Account...")
      let createUserAccountOp = CreateUserAccountOperation(status: status)
		
		let updateProfileInfoOp = BlockOperation {
			if status.error != nil {
				return
			}
			
			guard let user = status.user else { return }
			
			SMDatabaseLayer.addUserToDatabase(user)
			user.updateDisplayName("\(info.firstName) \(info.lastName)", completion: { (error) in
				status.error = error
			})
		}
		
		let startEmailVerificationOp = BlockOperation {
			if let error = status.error {
				SwiftSpinner.hide()
				controller.present(error: error as NSError)
				return
			}
			
			SwiftSpinner.hide()
			
			guard let user = status.user else { return }
			self._user = user
			DispatchQueue.main.async {
				self._startEmailVerification(user, presentationContext: controller, sendEmail: true)
			}
		}
		
		updateProfileInfoOp.addDependency(createUserAccountOp)
		startEmailVerificationOp.addDependency(updateProfileInfoOp)
		
		let ops = [createUserAccountOp, updateProfileInfoOp, startEmailVerificationOp] as [Any]
		_operationQueue.addOperations(ops as! [Operation], waitUntilFinished: false)
   }
}

// MARK: - EmailVerificationSentViewControllerDelegate
extension AppEntryFlowController: EmailVerificationSentViewControllerDelegate
{
   func emailVerificationSentViewController(_ controller: EmailVerificationSentViewController, resendButtonPressed button: UIButton) {
      if let user = _user {
			SwiftSpinner.show("Resending Verification Email...")
         user.sendEmailVerification({ (error) in
				
				SwiftSpinner.hide() {
					controller.presentMessage(message: "Verification email sent.")
				}
         })
      }
   }
   
   func emailVerificationSentViewController(_ controller: EmailVerificationSentViewController, logMeInButtonPressed button: UIButton) {
      guard let user = _user else {
         controller.dismiss(animated: true, completion: nil)
         return
      }
		
		SwiftSpinner.show("Checking email")
      user.reload({ (error) in
			
			SwiftSpinner.hide()
         if let error = error {
            controller.present(error: error as NSError)
         } else {
            if user.emailVerified {
               controller.dismiss(animated: true, completion: {
                  self._startProfileSetup(user, fromSignUp: true)
               })
            } else {
               guard let email = user.email else { return }
               controller.presentMessage(message: "The email address \(email) has not been verified.")
            }
         }
      })
   }
   
   func emailVerificationSentViewControllerCancelButtonPressed(_ controller: EmailVerificationSentViewController) {
      controller.dismiss(animated: true, completion: nil)
   }
}

// MARK: - WelcomeViewControllerDelegate
extension AppEntryFlowController: WelcomeViewControllerDelegate {
	
   func welcomeViewControllerShouldFinish(_ controller: WelcomeViewController)
	{
		_profileImageViewController.resetImage()
		_profileImageViewController.continueButtonEnabled = false
      _rootNavController.pushViewController(_profileImageViewController, animated: true)
   }
}

// MARK: - AddProfileImageViewControllerDelegate
extension AppEntryFlowController: AddProfileImageViewControllerDelegate {
	
	func addProfileImageViewControllerAddImagePressed(_ controller: AddProfileImageViewController) {
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
	
	func addProfileImageViewControllerContinuePressed(_ controller: AddProfileImageViewController) {
		guard let user = _user else { return }
		
		OneSignal.idsAvailable({ (playerID, apnsToken) in
			if playerID != nil {
				SwipeMealPushStorage.oneSignalPlayerID = playerID
				SMDatabaseLayer.update(oneSignalPlayerID: playerID!, forUser: user)
			}
			if apnsToken != nil {
				SwipeMealPushStorage.deviceToken = apnsToken
				SMDatabaseLayer.update(deviceToken: apnsToken!, forUser: user)
			}
		})
		
		let createStripeAccountOp = CreateStripeAccountOperation(user: user)
		createStripeAccountOp.completionBlock = {
			DispatchQueue.main.async {
				if let _ = createStripeAccountOp.error {
					controller.presentMessage(message: "Something went wrong with creating your account. Please try again.")
				} else {
					SMDatabaseLayer.setProfileSetupComplete(true, forUser: user)
					SMDatabaseLayer.addUserToRespectiveGroup(user)
					
					self._showHomeScreen()
				}
			}
		}
		
		createStripeAccountOp.start()
	}
	
	fileprivate func _showHomeScreen(animated: Bool = true) {
		DispatchQueue.main.async {
			let sb = UIStoryboard(name: "Main", bundle: nil)
			guard let initialController = sb.instantiateInitialViewController() else { return }
			self._rootNavController.setNavigationBarHidden(true, animated: animated)
			self._rootNavController.pushViewController(initialController, animated: animated)
		}
	}
}
