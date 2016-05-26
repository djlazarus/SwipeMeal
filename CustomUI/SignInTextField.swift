//
//  SignInTextField.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class SignInTextField: BottomBorderTextField, PlaceholderColorAdjustable
{
   override func awakeFromNib()
   {
      super.awakeFromNib()
      backgroundColor = UIColor.clearColor()
      
      let color = UIColor.whiteColor()
      textColor = color
      tintColor = color
      bottomBorderColor = color.colorWithAlphaComponent(0.5)
      adjustPlaceholder(color)
   }
}

class SignUpTextField: BottomBorderTextField, PlaceholderColorAdjustable
{
   override func awakeFromNib()
   {
      super.awakeFromNib()
      backgroundColor = UIColor.clearColor()
      
      let color = UIColor(white: 0.8, alpha: 1)
      textColor = color
      tintColor = color
      bottomBorderColor = color.colorWithAlphaComponent(0.5)
      adjustPlaceholder(color)
   }
}
