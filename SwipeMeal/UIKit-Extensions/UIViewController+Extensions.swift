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
   
   func presentStatus(status: SignUpInfoInvalidStatus)
   {
      dispatch_async(dispatch_get_main_queue()) { 
         self.errorPresenter.present(status)
      }
   }
}
