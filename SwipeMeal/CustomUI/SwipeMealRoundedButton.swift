//
//  SwipeMealRoundedButton.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class SwipeMealRoundedButton: UIButton
{
   override var highlighted: Bool {
      didSet {
         let colorAlpha: CGFloat = highlighted ? 0.05 : 0.10
         backgroundColor = UIColor(white: 1, alpha: colorAlpha)
      }
   }
   
   override func awakeFromNib()
   {
      super.awakeFromNib()
      
      backgroundColor = UIColor(white: 1, alpha: 0.10)
      layer.cornerRadius = 4
   }
}
