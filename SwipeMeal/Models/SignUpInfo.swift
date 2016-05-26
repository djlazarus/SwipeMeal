//
//  SignUpInfo.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

struct SignUpInfo
{
   let firstName: String
   let lastName: String
   let email: String
   let password: String
   let confirmedPassword: String
}

extension SignUpInfo
{
   init(controller: SignUpViewController)
   {
      let fn = controller.firstName
      let ln = controller.lastName
      let e = controller.email
      let p = controller.password
      let cp = controller.confirmedPassword
      
      self.init(firstName: fn, lastName: ln, email: e, password: p, confirmedPassword: cp)
   }
}