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
   private var errorPresenter: ErrorPresenterViewController {
      for viewController in childViewControllers {
         if let presenter = viewController as? ErrorPresenterViewController {
            return presenter
         }
      }
      return _createAndAddErrorPresenter()
   }
   
   private func _createAndAddErrorPresenter() -> ErrorPresenterViewController
   {
      let errorPresenter = ErrorPresenterViewController()
      addChildViewController(errorPresenter)
      errorPresenter.didMoveToParentViewController(self)
      
      view.addSubview(errorPresenter.view)
      return errorPresenter
   }
   
   func present(status: SignUpInfoInvalidStatus)
   {
      dispatch_async(dispatch_get_main_queue()) { 
         self.errorPresenter.presentStatus(status)
      }
   }
}

extension UIViewController
{
   static var storyboardID: String {
      // Get the name of current class
      let classString = NSStringFromClass(self)
      let components = classString.componentsSeparatedByString(".")
      assert(components.count > 0, "Failed extract class name from \(classString)")
      return components.last!
   }
   
   class func instantiate(type: StoryboardType) -> Self {
      let storyboard = UIStoryboard(type: type)
      return instantiateFromStoryboard(storyboard, type: self)
   }
   
   private class func instantiateFromStoryboard<T: UIViewController>(storyboard: UIStoryboard, type: T.Type) -> T {
      return storyboard.instantiateViewControllerWithIdentifier(self.storyboardID) as! T
   }
}
