//
//  SMAuthLayer.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias UserSignInCompletion = (_ user: SwipeMealUser?, _ error: Error?) -> Void
typealias CreateUserCompletion = (_ user: SwipeMealUser?, _ error: Error?) -> Void
typealias SendEmailVerificationCompletion = (_ error: Error?) -> Void
typealias ReloadUserProfileCompletion = (_ error: Error?) -> Void
typealias UpdateUserProfileCompletion = (_ error: Error?) -> Void

struct SMAuthLayer
{	
   static func createUser(_ email: String, password: String, completion: CreateUserCompletion?)
   {
      FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
         completion?(user, error)
      })
   }
   
   static func signIn(_ email: String, password: String, completion: UserSignInCompletion?)
   {
      FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
         completion?(user, error)
      })
   }
   
   static var currentUser: SwipeMealUser? {
      return FIRAuth.auth()?.currentUser
   }
}
