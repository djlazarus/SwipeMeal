//
//  UIStoryboard+Extensions.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

enum StoryboardType: String
{
   case LaunchScreen, SignIn, SignUp, Onboarding
}

extension UIStoryboard
{
   convenience init(type: StoryboardType)
   {
      self.init(name: type.rawValue, bundle: nil)
   }
}
