//
//  UIView+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 7/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

public extension UIView {
	public func addAndFill(subview subview: UIView) {
		addSubview(subview)
		subview.translatesAutoresizingMaskIntoConstraints = false
		subview.topAnchor.constraintEqualToAnchor(topAnchor).active = true
		subview.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
		subview.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
		subview.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
	}
	
	public func addBorder(withSize size: CGFloat, toEdge edge: UIRectEdge, padding: CGFloat = 0.0) -> UIView? {
		switch edge {
		case UIRectEdge.Top: return _addTopBorder(withSize: size, padding: padding)
		case UIRectEdge.Left: return _addLeftBorder(withSize: size, padding: padding)
		case UIRectEdge.Bottom: return _addBottomBorder(withSize: size, padding: padding)
		case UIRectEdge.Right: return _addRightBorder(withSize: size, padding: padding)
		default: return nil
		}
	}
	
	public func addBorders(withSize size: CGFloat, toEdges edges: UIRectEdge, padding: CGFloat = 0.0) -> [UIView] {
		var borders: [UIView] = []
		
		if edges.contains(.Top) {
			borders.append(_addTopBorder(withSize: size, padding: padding))
		}
		if edges.contains(.Left) {
			borders.append(_addLeftBorder(withSize: size, padding: padding))
		}
		if edges.contains(.Bottom) {
			borders.append(_addBottomBorder(withSize: size, padding: padding))
		}
		if edges.contains(.Right) {
			borders.append(_addRightBorder(withSize: size, padding: padding))
		}
		
		return borders
	}
	
	public func addBordersToAllEdges(borderSize size: CGFloat) -> [UIView] {
		return addBorders(withSize: size, toEdges: [.Top, .Right, .Bottom, .Left])
	}
	
	private func _addTopBorder(withSize size: CGFloat, padding: CGFloat) -> UIView {
		let border = UIView()
		addSubview(border)
		
		border.translatesAutoresizingMaskIntoConstraints = false
		border.topAnchor.constraintEqualToAnchor(topAnchor).active = true
		border.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: padding).active = true
		border.rightAnchor.constraintEqualToAnchor(rightAnchor, constant: -padding).active = true
		border.heightAnchor.constraintEqualToConstant(size).active = true
		
		return border
	}
	
	private func _addBottomBorder(withSize size: CGFloat, padding: CGFloat) -> UIView {
		let border = UIView()
		addSubview(border)
		
		border.translatesAutoresizingMaskIntoConstraints = false
		border.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
		border.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: padding).active = true
		border.rightAnchor.constraintEqualToAnchor(rightAnchor, constant: -padding).active = true
		border.heightAnchor.constraintEqualToConstant(size).active = true
		
		return border
	}
	
	private func _addLeftBorder(withSize size: CGFloat, padding: CGFloat) -> UIView {
		let border = UIView()
		addSubview(border)
		
		border.translatesAutoresizingMaskIntoConstraints = false
		border.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
		border.topAnchor.constraintEqualToAnchor(topAnchor, constant: padding).active = true
		border.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: -padding).active = true
		border.widthAnchor.constraintEqualToConstant(size).active = true
		
		return border
	}
	
	private func _addRightBorder(withSize size: CGFloat, padding: CGFloat) -> UIView {
		let border = UIView()
		addSubview(border)
		
		border.translatesAutoresizingMaskIntoConstraints = false
		border.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
		border.topAnchor.constraintEqualToAnchor(topAnchor, constant: padding).active = true
		border.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: -padding).active = true
		border.widthAnchor.constraintEqualToConstant(size).active = true
		
		return border
	}
}
