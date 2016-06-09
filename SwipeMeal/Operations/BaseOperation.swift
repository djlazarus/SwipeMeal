//
//  BaseOperation.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

private let kExecutingKey = "isExecuting"
private let kFinishedKey = "isFinished"

class BaseOperation: NSOperation
{
   // This is meant to provide the client with information as to whether the operation succeeded or failed.
   // Checking to see if it's nil or not is most useful in the completion block
   internal(set) var error: NSError?
   var useVerboseLogging = false
   
   override var asynchronous: Bool {
      return true
   }
   
   private var _executing = false {
      willSet {
         willChangeValueForKey(kExecutingKey)
      }
      didSet {
         didChangeValueForKey(kExecutingKey)
      }
   }
   
   override var executing: Bool {
      return _executing
   }
   
   private var _finished = false {
      willSet {
         willChangeValueForKey(kFinishedKey)
      }
      
      didSet {
         didChangeValueForKey(kFinishedKey)
      }
   }
   
   override var finished: Bool {
      return _finished
   }
   
   override func start() {
      _executing = true
      execute()
   }
   
   func execute() {
      fatalError("You must override this")
   }
   
   func finish() {
      _executing = false
      _finished = true
   }
   
   internal func finishWithError(error: NSError?)
   {
      if useVerboseLogging {
         print("FINISHING OP: \(self.dynamicType)")
      }
      self.error = error
      finish()
   }
}
