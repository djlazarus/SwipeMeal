//
//  SwipeMealErrors.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

enum SwipeMealErrors
{
   enum User
   {
      static var currentUserIsNil: NSError {
         let description = "Current User Error"
         let failureReason = "The current user is nil."
         let userInfo = [
            NSLocalizedFailureReasonErrorKey : failureReason,
            NSLocalizedDescriptionKey : description
            ]
         return NSError(domain: "com.SwipeMeal.ErrorDomain", code: 1234, userInfo: userInfo)
      }
      
      static var emailNotVerified: NSError {
         let description = "Email Verification Error"
         let failureReason = "The user's email has not yet been verified."
         let userInfo = [
            NSLocalizedFailureReasonErrorKey : failureReason,
            NSLocalizedDescriptionKey : description
         ]
         return NSError(domain: "com.SwipeMeal.ErrorDomain", code: 1235, userInfo: userInfo)
      }
   }
}