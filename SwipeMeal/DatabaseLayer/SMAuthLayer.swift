//
//  SMAuthLayer.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias UserSignInCompletion = (user: SwipeMealUser?, error: NSError?) -> Void
typealias CreateUserCompletion = (user: SwipeMealUser?, error: NSError?) -> Void
typealias SendEmailVerificationCompletion = (error: NSError?) -> Void
typealias ReloadUserProfileCompletion = (error: NSError?) -> Void
typealias UpdateUserProfileCompletion = (error: NSError?) -> Void

struct SMAuthLayer
{	
   static func createUser(email: String, password: String, completion: CreateUserCompletion?)
   {
      FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
         completion?(user: user, error: error)
      })
   }
   
   static func signIn(email: String, password: String, completion: UserSignInCompletion?)
   {
      FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
         completion?(user: user, error: error)
      })
   }
   
   static var currentUser: SwipeMealUser? {
      return FIRAuth.auth()?.currentUser
   }
}
