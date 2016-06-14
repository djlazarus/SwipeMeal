//
//  CreateUserAccountOperation.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class CreateUserAccountStatus
{
   let info: SignUpInfo
   var user: SwipeMealUser?
   var error: NSError?
   
   init(info: SignUpInfo) {
      self.info = info
   }
}

class CreateUserAccountOperation: BaseOperation
{
   let status: CreateUserAccountStatus
   
   init(status: CreateUserAccountStatus) {
      self.status = status
   }
   
   override func execute()
   {
      SMAuthLayer.createUser(status.info.email, password: status.info.password) { (user, error) in
         self.status.user = user
         self.status.error = error
         self.finish()
      }
   }
}
