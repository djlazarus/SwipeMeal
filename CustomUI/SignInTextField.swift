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
      adjustPlaceholder(UIColor.whiteColor())
   }
}
