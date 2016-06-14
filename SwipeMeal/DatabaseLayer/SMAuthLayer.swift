//
//  SMAuthLayer.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias UserSignInCompletion = (user: SMUser?, error: NSError?) -> Void
typealias CreateUserCompletion = (user: SMUser?, error: NSError?) -> Void
typealias SendEmailVerificationCompletion = (error: NSError?) -> Void
typealias ReloadUserProfileCompletion = (error: NSError?) -> Void

struct SMAuthLayer
{
   static func createUser(email: String, password: String, completion: CreateUserCompletion?)
   {
      FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
         if let user = user {
            completion?(user: SMUser(user: user), error: error)
         }
         else {
            completion?(user: nil, error: error)
         }
      })
   }
   
   static func signIn(email: String, password: String, completion: UserSignInCompletion?)
   {
      FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
         if let user = user {
            completion?(user: SMUser(user: user), error: error)
         }
         else {
            completion?(user: nil, error: error)
         }
      })
   }
   
   static func sendEmailVerificationToCurrentUser(completion: SendEmailVerificationCompletion?)
   {
      if let user = FIRAuth.auth()?.currentUser {
         user.sendEmailVerificationWithCompletion { (error) in
            completion?(error: error)
         }
      }
      else {
         completion?(error: .currentUserNilError())
      }
   }
   
   static func reloadCurrentUserData(completion: ReloadUserProfileCompletion?)
   {
      if let user = FIRAuth.auth()?.currentUser {
         user.reloadWithCompletion({ (error) in
            completion?(error: error)
         })
      }
      else {
         completion?(error: .currentUserNilError())
      }
   }
   
   static var currentUserEmailVerified: Bool {
      guard let user = FIRAuth.auth()?.currentUser else { assert(false, "current user is nil"); return false }
      return user.emailVerified
   }
   
   static var currentUser: SMUser? {
      guard let user = FIRAuth.auth()?.currentUser else { assert(false, "current user is nil"); return nil }
      return SMUser(user: user)
   }
}

extension NSError
{
   static func currentUserNilError() -> NSError
   {
      let failureReason = "Current user is nil"
      let userInfo = [NSLocalizedFailureReasonErrorKey : failureReason]
      return NSError(domain: "com.SwipeMeal.ErrorDomain", code: 1234, userInfo: userInfo)
   }
}
