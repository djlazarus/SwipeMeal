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
}