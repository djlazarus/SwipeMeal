//
//  UICollectionView+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 6/28/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

public extension UICollectionView
{
	public var lastIndexPath: IndexPath? {
		var ip: NSIndexPath?
		let numberOfRows = numberOfItems(inSection: 0)
		if numberOfRows > 0 {
			ip = NSIndexPath(row: numberOfRows - 1, section: 0)
		}
		return ip as? IndexPath
	}
	
	public func deselectAllItems(animated: Bool = false)
	{
		for indexPath in self.indexPathsForSelectedItems ?? [] {
			self.deselectItem(at: indexPath, animated: animated)
		}
	}
	
	public func scrollToBottom(animated: Bool = true)
	{
		if let ip = lastIndexPath {
			scrollToItem(at: ip as IndexPath, at: .centeredVertically, animated: animated)
		}
	}
	
	public func scrollToBottomWithDuration(duration: Double, completion: ((_ finished: Bool) -> Void)?)
	{
		UIView.animate(withDuration: duration, animations: { () -> Void in
			
			if let ip = self.lastIndexPath {
				self.scrollToItem(at: ip, at: .bottom, animated: false)
			}
			}, completion: completion)
	}
}
