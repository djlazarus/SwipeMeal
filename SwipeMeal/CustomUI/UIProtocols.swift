//
//  UIProtocols.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol PlaceholderColorAdjustable { }

extension PlaceholderColorAdjustable where Self: UITextField
{
   func adjustPlaceholder(color: UIColor)
   {
      let placeholderText = placeholder ?? ""
      let placeholderFont = font ?? UIFont.systemFontOfSize(12)
      
      let placeholderAttributes = [NSFontAttributeName : placeholderFont, NSForegroundColorAttributeName : color]
      
      let attributedTitle = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
      attributedPlaceholder = attributedTitle
   }
}