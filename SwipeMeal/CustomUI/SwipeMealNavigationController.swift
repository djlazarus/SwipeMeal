//
//  SwipeMealNavigationControllerViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class SwipeMealNavigationController: UINavigationController
{
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }
   
   override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
      super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
   }
   
   override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
   }
   
   convenience init()
   {
      self.init(navigationBarClass: SwipeMealNavigationBar.self, toolbarClass: UIToolbar.self)
   }
}
