//
//  PresentationOperation.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class PresentationOperation: BaseOperation
{
   private let _viewControllerPresentationContext: UIViewController?
   private let _navigationControllerPresentationContext: UINavigationController?
   
   init(presentingViewController: UIViewController)
   {
      _viewControllerPresentationContext = presentingViewController
      _navigationControllerPresentationContext = nil
      
      super.init()
      commonInit()
   }
   
   init(presentingNavigationController: UINavigationController)
   {
      _navigationControllerPresentationContext = presentingNavigationController
      _viewControllerPresentationContext = nil
      
      super.init()
      commonInit()
   }
   
   internal func commonInit()
   {
   }
   
   internal func presentViewController(controller: UIViewController, completion: (() -> Void)? = nil)
   {
      guard let presentationContext = _viewControllerPresentationContext else { return }
      dispatch_async(dispatch_get_main_queue()) {
         presentationContext.presentViewController(controller, animated: true, completion: completion)
      }
   }
   
   internal func dismissViewController(controller: UIViewController, completion: (() -> Void)? = nil)
   {
      dispatch_async(dispatch_get_main_queue()) { 
         controller.dismissViewControllerAnimated(true, completion: completion)
      }
   }
   
   internal func pushViewController(controller: UIViewController)
   {
      guard let presentationContext = _navigationControllerPresentationContext else { return }
      dispatch_async(dispatch_get_main_queue()) {
         presentationContext.pushViewController(controller, animated: true)
      }
   }
   
   internal func popTopmostViewController(animated: Bool = true)
   {
      guard let presentationContext = _navigationControllerPresentationContext else { return }
      dispatch_async(dispatch_get_main_queue()) {
         presentationContext.popViewControllerAnimated(animated)
      }
   }
   
   internal func popToRootViewController(animated: Bool = true)
   {
      guard let presentationContext = _navigationControllerPresentationContext else { return }
      dispatch_async(dispatch_get_main_queue()) {
         presentationContext.popToRootViewControllerAnimated(animated)
      }
   }
}
