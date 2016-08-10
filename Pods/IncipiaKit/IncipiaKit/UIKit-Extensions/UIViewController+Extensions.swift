//
//  UIViewController+AlertPresenting.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

private class ErrorPresenterViewController: UIViewController
{
	private var _isVisible = false
	private lazy var _okAction: UIAlertAction = {
		return UIAlertAction(title: "OK", style: .Default, handler: nil)
	}()
	
	private func _okAction(completion: (UIAlertAction -> Void)? = nil) -> UIAlertAction {
		return UIAlertAction(title: "OK", style: .Default, handler: completion)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.alpha = 0
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewDidAppear(animated)
		_isVisible = true
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		_isVisible = false
	}
	
	override func present(error: NSError, completion: (UIAlertAction -> Void)? = nil) {
		guard _isVisible == true else { return }
		
		let alertController = UIAlertController(title: error.localizedDescription, message: error.localizedFailureReason, preferredStyle: .Alert)
		alertController.addAction(_okAction(completion))
		presentViewController(alertController, animated: true, completion: nil)
	}
	
	override func presentMessage(message: String, completion: (UIAlertAction -> Void)? = nil) {
		guard _isVisible == true else { return }
		
		let alertController = UIAlertController(title: message, message: nil, preferredStyle: .Alert)
		alertController.addAction(_okAction(completion))
		presentViewController(alertController, animated: true, completion: nil)
	}
}

public extension UIViewController
{
	// MARK: - Error Presenting
	private var errorPresenter: ErrorPresenterViewController {
		for viewController in childViewControllers {
			if let presenter = viewController as? ErrorPresenterViewController {
				return presenter
			}
		}
		return _createAndAddErrorPresenter()
	}
	
	private func _createAndAddErrorPresenter() -> ErrorPresenterViewController {
		let errorPresenter = ErrorPresenterViewController()
		addChildViewController(errorPresenter)
		errorPresenter.didMoveToParentViewController(self)
		
		view.addSubview(errorPresenter.view)
		return errorPresenter
	}
	
	public func present(error: NSError, completion: (UIAlertAction -> Void)? = nil) {
		dispatch_async(dispatch_get_main_queue()) {
			self.errorPresenter.present(error, completion: completion)
		}
	}
	
	public func presentMessage(message: String, completion: (UIAlertAction -> Void)? = nil) {
		dispatch_async(dispatch_get_main_queue()) {
			self.errorPresenter.presentMessage(message, completion: completion)
		}
	}
	
	// MARK: - Bar Button Items
	public func removeLeftBarItem() {
		navigationItem.setLeftBarButtonItems([UIBarButtonItem.empty], animated: false)
	}
	
	public func removeRightBarItem() {
		navigationItem.setRightBarButtonItems([UIBarButtonItem.empty], animated: false)
	}
	
	public func usePlainArrowForBackButtonItem(withAction action: Selector? = nil) {
		let itemAction = action ?? #selector(UIViewController.ik_backButtonPressed)
		let item = UIBarButtonItem.back(target: self, action: itemAction)
		navigationItem.setLeftBarButtonItems([item], animated: false)
	}
	
	public func updateLeftBarButtonItem(withImageName name: String, action: Selector) {
		let item = UIBarButtonItem(image: UIImage(named: name), style: .Plain, target: self, action: action)
		navigationItem.setLeftBarButtonItems([item], animated: false)
	}
	
	public func updateRightBarButtonItem(withImageName name: String, action: Selector) {
		let item = UIBarButtonItem(image: UIImage(named: name), style: .Plain, target: self, action: action)
		navigationItem.setRightBarButtonItems([item], animated: false)
	}
	
	public func updateLeftBarButtonItem(withTitle title: String, action: Selector) {
		let item = UIBarButtonItem(title: title, style: .Plain, target: self, action: action)
		navigationItem.setLeftBarButtonItems([item], animated: false)
	}
	
	public func updateRightBarButtonItem(withTitle title: String, action: Selector) {
		let item = UIBarButtonItem(title: title, style: .Plain, target: self, action: action)
		navigationItem.setRightBarButtonItems([item], animated: false)
	}
	
	@objc private func ik_backButtonPressed() {
		navigationController?.popViewControllerAnimated(true)
	}
	
	// MARK: - Navigation Bar
	public func makeNavBarTransparent() {
		navigationController?.makeNavBarTransparent()
	}
	
	public func makeNavBarShadowTransparent() {
		navigationController?.makeNavBarShadowTransparent()
	}
	
	public func resetNavBarTransparency() {
		navigationController?.resetNavBarTransparency()
	}
	
	public func resetNavBarShadow() {
		navigationController?.resetNavBarShadow()
	}
	
	public func updateNavBar(withColor color: UIColor) {
		navigationController?.updateNavBar(withColor: color)
	}
	
	public func updateNavBarTintWithColor(color: UIColor) {
		navigationController?.navigationBar.tintColor = color
		navigationController?.navigationBar.barTintColor = color
	}
	
	// MARK: - Child View Controllers
	func add(childViewController vc: UIViewController, toContainer container: UIView) {
		addChildViewController(vc)
		container.addAndFill(subview: vc.view)
		vc.didMoveToParentViewController(self)
	}
	
	// MARK: - Initialization
	public static var className: String {
		let classString = NSStringFromClass(self)
		let components = classString.componentsSeparatedByString(".")
		assert(components.count > 0, "Failed extract class name from \(classString)")
		return components.last!
	}
	
	// This method only works if the view controller's ID is the same as the class name
	public class func instantiate(fromStoryboard name: String) -> Self {
		let storyboard = UIStoryboard(name: name, bundle: nil)
		return instantiateFromStoryboard(storyboard, type: self)
	}
	
	private class func instantiateFromStoryboard<T: UIViewController>(storyboard: UIStoryboard, type: T.Type) -> T {
		return storyboard.instantiateViewControllerWithIdentifier(self.className) as! T
	}
}

public extension UIViewControllerContextTransitioning {
	public var toViewController: UIViewController? {
		return viewControllerForKey(UITransitionContextToViewControllerKey)
	}
	
	public var fromViewController: UIViewController? {
		return viewControllerForKey(UITransitionContextFromViewControllerKey)
	}
}