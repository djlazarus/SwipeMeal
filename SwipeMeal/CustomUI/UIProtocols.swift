//
//  UIProtocols.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol PlaceholderColorAdjustable { }

protocol TransparencyAdjustable
{
   func makeTransparent()
}

protocol CornerRadiusAdjustable
{
   func makeCircular()
   func adjustCornerRadius(_ radius: CGFloat)
}

extension PlaceholderColorAdjustable where Self: UITextField
{
   func adjustPlaceholder(_ color: UIColor)
   {
      let placeholderText = placeholder ?? ""
      let placeholderFont = font ?? UIFont.systemFont(ofSize: 12)
      
      let placeholderAttributes = [NSFontAttributeName : placeholderFont, NSForegroundColorAttributeName : color]
      
      let attributedTitle = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
      attributedPlaceholder = attributedTitle
   }
}

extension TransparencyAdjustable where Self: UINavigationBar
{
   func makeTransparent()
   {
      setBackgroundImage(UIImage(), for: .default)
      shadowImage = UIImage()
   }
}

extension TransparencyAdjustable where Self: UINavigationController
{
   func makeTransparent()
   {
      let bar: TransparencyAdjustable? = navigationBar as? TransparencyAdjustable
      bar?.makeTransparent()
   }
}

extension CornerRadiusAdjustable where Self: UIView
{
   func makeCircular()
   {
      layer.cornerRadius = min(bounds.width, bounds.height) * 0.5
   }
   
   func adjustCornerRadius(_ radius: CGFloat)
   {
      layer.cornerRadius = radius
   }
}
