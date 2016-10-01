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

class BaseOperation: Operation
{
   // This is meant to provide the client with information as to whether the operation succeeded or failed.
   // Checking to see if it's nil or not is most useful in the completion block
   internal(set) var error: NSError?
   var useVerboseLogging = false
   
   override var isAsynchronous: Bool {
      return true
   }
   
   fileprivate var _executing = false {
      willSet {
         willChangeValue(forKey: kExecutingKey)
      }
      didSet {
         didChangeValue(forKey: kExecutingKey)
      }
   }
   
   override var isExecuting: Bool {
      return _executing
   }
   
   fileprivate var _finished = false {
      willSet {
         willChangeValue(forKey: kFinishedKey)
      }
      
      didSet {
         didChangeValue(forKey: kFinishedKey)
      }
   }
   
   override var isFinished: Bool {
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
   
   internal func finishWithError(_ error: NSError?)
   {
      if useVerboseLogging {
         print("FINISHING OP: \(type(of: self))")
      }
      self.error = error
      finish()
   }
}
