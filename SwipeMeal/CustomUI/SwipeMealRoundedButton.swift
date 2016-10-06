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
   override var isHighlighted: Bool {
      didSet {
         let colorAlpha: CGFloat = isHighlighted ? 0.05 : 0.10
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

class SwipeMealAddProfileImageButton: UIButton
{
   override func awakeFromNib() {
      super.awakeFromNib()
      layer.cornerRadius = 24
      
      layer.shadowOpacity = 0.25
      layer.shadowOffset = CGSize(width: 0, height: 2)
      layer.shadowRadius = 3
   }
}
