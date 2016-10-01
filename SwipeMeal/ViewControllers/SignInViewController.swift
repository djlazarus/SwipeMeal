//
//  SignInViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/23/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol SignInViewControllerDelegate: class
{
   func signInViewControllerSignInButtonPressed(_ controller: SignInViewController, email: String, password: String)
   func signInViewController(_ controller: SignInViewController, signUpButtonPressed: UIButton)
   
   func signInViewController(_ controller: SignInViewController, forgotPasswordButtonPressed: UIButton)
}

class SignInViewController: UIViewController
{
   weak var delegate: SignInViewControllerDelegate?
   
   @IBOutlet fileprivate var _usernameTextField: SignInTextField!
   @IBOutlet fileprivate var _passwordTextField: SignInTextField!
   @IBOutlet fileprivate var _keyboardAvoidingConstraint: NSLayoutConstraint!
   
   fileprivate let _operationQueue = OperationQueue()
   
   deinit {
      _unsubscribeFromKeyboardNotifications()
   }
   
   // MARK: - Overridden
   override func viewDidLoad()
   {
      super.viewDidLoad()
      _subscribeForKeyboardNotifications()
   }
   
   override var preferredStatusBarStyle : UIStatusBarStyle {
      return .lightContent
   }
   
   // MARK: - Setup
   fileprivate func _subscribeForKeyboardNotifications()
   {
      let center = NotificationCenter.default
      center.addObserver(self, selector: #selector(SignInViewController.keyboardWillChangeHeight(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
   }
   
   fileprivate func _unsubscribeFromKeyboardNotifications()
   {
      let center = NotificationCenter.default
      center.removeObserver(self)
   }
   
   // MARK: - Actions
   @IBAction fileprivate func _viewTapped(_ recognizer: UIGestureRecognizer)
   {
      guard let textFieldSuperview = _usernameTextField.superview else { return }
      
      let location = recognizer.location(in: textFieldSuperview)
      guard !_usernameTextField.frame.contains(location) && !_passwordTextField.frame.contains(location) else { return }
      
      _usernameTextField.resignFirstResponder()
      _passwordTextField.resignFirstResponder()
   }
   
   @IBAction fileprivate func _signUpButtonPressed(_ sender: UIButton)
   {
      delegate?.signInViewController(self, signUpButtonPressed: sender)
   }
   
   @IBAction fileprivate func _signInButtonPressed(_ sender: UIButton)
   {
      guard let email = _usernameTextField.text else { return }
      guard let password = _passwordTextField.text else { return }
      
      delegate?.signInViewControllerSignInButtonPressed(self, email: email, password: password)
   }
   
   @IBAction fileprivate func _forgotPasswordButtonPressed(_ sender: UIButton)
   {
      delegate?.signInViewController(self, forgotPasswordButtonPressed: sender)
   }
   
   internal func keyboardWillChangeHeight(_ notification: Notification)
   {
      guard let userInfo = (notification as NSNotification).userInfo else { return }
      guard let frameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else { return }
      
      let convertedFrameEnd = view.convert(frameEnd, from: nil)
      let passwordFrame = _passwordTextField.superview!.convert(_passwordTextField.frame, to: nil)
      
      let padding: CGFloat = 10
      var offset = (passwordFrame.maxY + padding) - convertedFrameEnd.minY + _keyboardAvoidingConstraint.constant
      offset = max(offset, 0)
      
      _keyboardAvoidingConstraint.constant = offset
      
      guard let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as AnyObject).uint32Value else { return }
      guard let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
      let options = UIViewAnimationOptions(rawValue: UInt(curve) << 16)
      
      UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
         self.view.layoutIfNeeded()
         }, completion: nil
      )
   }
}

extension SignInViewController: UITextFieldDelegate
{
   func textFieldShouldReturn(_ textField: UITextField) -> Bool
   {
      switch textField {
      case _usernameTextField:
         _passwordTextField.becomeFirstResponder()
         return false
      case _passwordTextField:
         _passwordTextField.resignFirstResponder()
         return true
      default:
         return true
      }
   }
}
