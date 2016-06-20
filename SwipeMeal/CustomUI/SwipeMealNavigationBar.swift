//
//  SwipeMealNavigationBar.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class SwipeMealNavigationBar: UINavigationBar, TransparencyAdjustable
{
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      _commonInit()
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      _commonInit()
   }
   
   private func _commonInit()
   {
      makeTransparent()
      barStyle = .Black
   }
}
