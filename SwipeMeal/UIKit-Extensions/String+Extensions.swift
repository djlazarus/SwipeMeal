//
//  String+Extensions.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

extension String
{
   var trimmed: String {
      return self.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
   }
   
   var isValidEmail: Bool {
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
      let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
      return emailTest.evaluateWithObject(self)
   }
}