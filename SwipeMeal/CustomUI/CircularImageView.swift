//
//  CircularImageView.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class CircularImageView: UIImageView, CornerRadiusAdjustable
{
   override func awakeFromNib() {
      super.awakeFromNib()
      layer.masksToBounds = true
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      makeCircular()
   }
}
