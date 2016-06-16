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
   var infoInvalidStatus: SignUpInfoInvalidStatus? = nil
   
   var user: SwipeMealUser?
   var error: NSError?
   
   init(info: SignUpInfo) {
      self.info = info
   }
}

class CreateUserAccountOperation: BaseOperation
{
   private let _status: CreateUserAccountStatus
   private let _internalQueue = NSOperationQueue()
   
   init(status: CreateUserAccountStatus) {
      self._status = status
   }
   
   override func execute()
   {
      let validateSignUpInfoOp = NSBlockOperation {
         let validator = SignUpInfoValidator(info: self._status.info)
         self._status.infoInvalidStatus = validator.validate()
      }
      
      let createUserAccountOp = NSBlockOperation {
         guard self._status.infoInvalidStatus == nil else {
            self.finish()
            return
         }
         
         SMAuthLayer.createUser(self._status.info.email, password: self._status.info.password) { (user, error) in
            self._status.user = user
            self._status.error = error
            self.finish()
         }
      }
      
      createUserAccountOp.addDependency(validateSignUpInfoOp)
      _internalQueue.addOperations([validateSignUpInfoOp, createUserAccountOp], waitUntilFinished: false)
   }
}
