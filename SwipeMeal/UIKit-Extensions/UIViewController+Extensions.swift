//
//  UIViewController+Extensions.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

extension UIViewController
{
   static var storyboardID: String {
      // Get the name of current class
      let classString = NSStringFromClass(self)
      let components = classString.components(separatedBy: ".")
      assert(components.count > 0, "Failed extract class name from \(classString)")
      return components.last!
   }
   
   class func instantiate(_ type: StoryboardType) -> Self {
      let storyboard = UIStoryboard(type: type)
      return instantiateFromStoryboard(storyboard, type: self)
   }
   
   fileprivate class func instantiateFromStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, type: T.Type) -> T {
      return storyboard.instantiateViewController(withIdentifier: self.storyboardID) as! T
   }
}
