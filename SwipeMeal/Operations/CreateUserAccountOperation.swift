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
   var error: Error?
   
   init(info: SignUpInfo) {
      self.info = info
   }
}

class CreateUserAccountOperation: BaseOperation
{
   fileprivate let _status: CreateUserAccountStatus
   fileprivate let _internalQueue = OperationQueue()
   
   init(status: CreateUserAccountStatus) {
      self._status = status
   }
   
   override func execute()
   {
      let validateSignUpInfoOp = BlockOperation {
         let validator = SignUpInfoValidator(info: self._status.info)
         
         if let invalidStatus = validator.validate() {
            self._status.error = SwipeMealErrors.error(invalidStatus)
         }
      }
      
      let createUserAccountOp = BlockOperation {
         guard self._status.error == nil else {
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
