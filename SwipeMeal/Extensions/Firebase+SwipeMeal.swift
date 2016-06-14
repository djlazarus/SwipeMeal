//
//  Firebase+SwipeMeal.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import FirebaseAuth

extension FIRUser: SwipeMealUser
{
   func reload(completion: ReloadUserProfileCompletion?)
   {
      reloadWithCompletion(completion)
   }
   
   func sendEmailVerification(completion: SendEmailVerificationCompletion?)
   {
      sendEmailVerificationWithCompletion(completion)
   }
}
