//
//  AuthenticateLoginOperation.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/16/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

class AuthenticateLoginStatus
{
   let email: String
   let password: String
   
   var user: SwipeMealUser?
   var error: NSError?
   
   init(email: String, password: String)
   {
      self.email = email
      self.password = password
   }
}

class AuthenticateLoginOperation: BaseOperation
{
   private let _status: AuthenticateLoginStatus
   
   init(status: AuthenticateLoginStatus)
   {
      _status = status
   }
   
   override func execute()
   {
      SMAuthLayer.signIn(_status.email, password: _status.password) { (user, error) in
         self._status.user = user
         self._status.error = error
         self.finish()
      }
   }
}