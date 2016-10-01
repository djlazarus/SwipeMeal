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
   internal let _viewControllerPresentationContext: UIViewController?
   internal let _navigationControllerPresentationContext: UINavigationController?
   
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
   
   internal func presentViewController(_ controller: UIViewController, completion: (() -> Void)? = nil)
   {
      guard let presentationContext = _viewControllerPresentationContext else { return }
      DispatchQueue.main.async {
         presentationContext.present(controller, animated: true, completion: completion)
      }
   }
   
   internal func dismissViewController(_ controller: UIViewController, completion: (() -> Void)? = nil)
   {
      DispatchQueue.main.async { 
         controller.dismiss(animated: true, completion: completion)
      }
   }
   
   internal func pushViewController(_ controller: UIViewController)
   {
      guard let presentationContext = _navigationControllerPresentationContext else { return }
      DispatchQueue.main.async {
         presentationContext.pushViewController(controller, animated: true)
      }
   }
   
   internal func popTopmostViewController(_ animated: Bool = true)
   {
      guard let presentationContext = _navigationControllerPresentationContext else { return }
      DispatchQueue.main.async {
         presentationContext.popViewController(animated: animated)
      }
   }
   
   internal func popToRootViewController(_ animated: Bool = true)
   {
      guard let presentationContext = _navigationControllerPresentationContext else { return }
      DispatchQueue.main.async {
         presentationContext.popToRootViewController(animated: animated)
      }
   }
}
