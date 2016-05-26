//
//  SignInViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/23/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController
{
   @IBOutlet private var _usernameTextField: SignInTextField!
   @IBOutlet private var _passwordTextField: SignInTextField!
   @IBOutlet private var _keyboardAvoidingConstraint: NSLayoutConstraint!
   
   private let _operationQueue = NSOperationQueue()
   
   deinit {
      _unsubscribeFromKeyboardNotifications()
   }
   
   // MARK: - Overridden
   override func viewDidLoad()
   {
      super.viewDidLoad()
      _subscribeForKeyboardNotifications()
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return .LightContent
   }
   
   // MARK: - Setup
   private func _subscribeForKeyboardNotifications()
   {
      let center = NSNotificationCenter.defaultCenter()
      center.addObserver(self, selector: #selector(SignInViewController.keyboardWillChangeHeight(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
   }
   
   private func _unsubscribeFromKeyboardNotifications()
   {
      let center = NSNotificationCenter.defaultCenter()
      center.removeObserver(self)
   }
   
   // MARK: - Actions
   @IBAction private func _viewTapped(recognizer: UIGestureRecognizer)
   {
      guard let textFieldSuperview = _usernameTextField.superview else { return }
      
      let location = recognizer.locationInView(textFieldSuperview)
      guard !_usernameTextField.frame.contains(location) && !_passwordTextField.frame.contains(location) else { return }
      
      _usernameTextField.resignFirstResponder()
      _passwordTextField.resignFirstResponder()
   }
   
   @IBAction private func _signUpButtonPressed()
   {
      let signUpOperation = SignUpOperation(presentingViewController: self)
      _operationQueue.addOperation(signUpOperation)
   }
   
   internal func keyboardWillChangeHeight(notification: NSNotification)
   {
      guard let userInfo = notification.userInfo else { return }
      guard let frameEnd = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue else { return }
      
      let convertedFrameEnd = view.convertRect(frameEnd, fromView: nil)
      let passwordFrame = _passwordTextField.superview!.convertRect(_passwordTextField.frame, toView: nil)
      
      let padding: CGFloat = 10
      var offset = (passwordFrame.maxY + padding) - convertedFrameEnd.minY + _keyboardAvoidingConstraint.constant
      offset = max(offset, 0)
      
      _keyboardAvoidingConstraint.constant = offset
      
      guard let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey]?.unsignedIntValue else { return }
      guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue else { return }
      let options = UIViewAnimationOptions(rawValue: UInt(curve) << 16)
      
      UIView.animateWithDuration(duration, delay: 0, options: options, animations: {
         self.view.layoutIfNeeded()
         }, completion: nil
      )
   }
}

extension SignInViewController: UITextFieldDelegate
{
   func textFieldShouldBeginEditing(textField: UITextField) -> Bool
   {
      return true
   }
}
