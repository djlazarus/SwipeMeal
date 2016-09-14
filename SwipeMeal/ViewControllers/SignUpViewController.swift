//
//  SignUpViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol SignUpViewControllerDelegate: class
{
   func signUpViewControllerSignInButtonPressed(controller: SignUpViewController)
   func signUpViewControllerRegisterButtonPressed(controller: SignUpViewController)
}

class SignUpViewController: UIViewController
{
   // MARK: - Public Properites
   weak var delegate: SignUpViewControllerDelegate?
   
   var firstName: String {
      return _firstNameTextField.text?.trimmed ?? ""
   }
   var lastName: String {
      return _lastNameTextField.text?.trimmed ?? ""
   }
   var email: String {
      return _emailTextField.text?.trimmed ?? ""
   }
   var password: String {
      return _passwordTextField.text?.trimmed ?? ""
   }
   var confirmedPassword: String {
      return _confirmPasswordTextField.text?.trimmed ?? ""
   }
   
   // MARK: - Private Properties
   private var _initialKeyboardAvoidingConstant: CGFloat = 0
   
   // MARK: - Outlets
   @IBOutlet private var _firstNameTextField: SignUpTextField!
   @IBOutlet private var _lastNameTextField: SignUpTextField!
   @IBOutlet private var _emailTextField: SignUpTextField!
   @IBOutlet private var _passwordTextField: SignUpTextField!
   @IBOutlet private var _confirmPasswordTextField: SignUpTextField!
   
   @IBOutlet private var _textFieldsContainer: UIView!
   @IBOutlet private var _textFields: [UITextField]!
   @IBOutlet private var _lastTextField: UITextField!
   
   @IBOutlet private var _keyboardAvoidingConstraint: NSLayoutConstraint! {
      didSet {
         _initialKeyboardAvoidingConstant = _keyboardAvoidingConstraint.constant
      }
   }
	
	private let _legalController = LegalDocumentationViewController.instantiate(fromStoryboard: "SignUp")
   
   // MARK: - Computed Properties
   private var _activeTextField: UITextField? {
      return _textFields.filter({ $0.isFirstResponder() }).first
   }
   
   private var _keyboardPadding: CGFloat {
      guard let field = _activeTextField else { return 0 }
      let padding: CGFloat = 10
      return field === _lastTextField ? padding : field.bounds.height + padding
   }
   
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
   
   // MARK: - Setup / Teardown
   private func _subscribeForKeyboardNotifications()
   {
      let center = NSNotificationCenter.defaultCenter()
      center.addObserver(self, selector: #selector(SignUpViewController.keyboardWillChangeHeight(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
   }
   
   private func _unsubscribeFromKeyboardNotifications()
   {
      let center = NSNotificationCenter.defaultCenter()
      center.removeObserver(self)
   }
   
   // MARK: - Actions
   @IBAction private func _signInButtonPressed() {
      delegate?.signUpViewControllerSignInButtonPressed(self)
   }
   
   @IBAction private func _registerButtonPressed() {
      delegate?.signUpViewControllerRegisterButtonPressed(self)
   }
	
	@IBAction private func _termsOfUsePressed() {
		_legalController.type = .TermsOfUse
		presentViewController(_legalController, animated: true, completion: nil)
	}
	
	@IBAction private func _privacyPolicyPressed() {
		_legalController.type = .PrivacyPolicy
		presentViewController(_legalController, animated: true, completion: nil)
	}
   
   // MARK: - Gesture Recognizers
   @IBAction private func _viewTapped(recognizer: UIGestureRecognizer)
   {
      let location = recognizer.locationInView(_textFieldsContainer)
      
      var shouldResign = true
      for field in _textFields {
         if field.frame.contains(location) {
            shouldResign = false
            break
         }
      }
      
      if shouldResign {
         _resignAllTextFields()
      }
   }
   
   // MARK: - Private
   private func _resignAllTextFields()
   {
      _textFields.forEach { field in
         field.resignFirstResponder()
      }
   }
   
   private func _nextTextField(field: UITextField) -> UITextField?
   {
      switch field {
      case _firstNameTextField: return _lastNameTextField
      case _lastNameTextField: return _emailTextField
      case _emailTextField: return _passwordTextField
      case _passwordTextField: return _confirmPasswordTextField
      case _confirmPasswordTextField: return nil
      default: return nil
      }
   }
   
   // MARK: - Keyboard
   internal func keyboardWillChangeHeight(notification: NSNotification)
   {
      guard let userInfo = notification.userInfo else { return }
      guard let frameEnd = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue else { return }
      
      let convertedFrameEnd = view.convertRect(frameEnd, fromView: nil)
      
      var textFieldFrame = CGRect.zero
      if let frame = _activeTextField?.frame {
         textFieldFrame = _textFieldsContainer.convertRect(frame, toView: nil)
      }

      var offset = (textFieldFrame.maxY + _keyboardPadding) - convertedFrameEnd.minY + _keyboardAvoidingConstraint.constant
      offset = max(offset, _initialKeyboardAvoidingConstant)
      
      _keyboardAvoidingConstraint.constant = offset
      
      guard let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey]?.unsignedIntValue else { return }
      guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue else { return }
      let options = UIViewAnimationOptions(rawValue: UInt(curve) << 16)
      
      UIView.animateWithDuration(duration, delay: 0, options: options, animations: {
         self.view.layoutIfNeeded()
         }, completion: nil
      )
   }
   
   // MARK: - Public
   func dismissKeyboard()
   {
      _resignAllTextFields()
   }
}

extension SignUpViewController: UITextFieldDelegate
{
   func textFieldShouldReturn(textField: UITextField) -> Bool
   {
      _nextTextField(textField)?.becomeFirstResponder()
      if textField == _lastTextField {
         textField.resignFirstResponder()
      }
      
      return true
   }
}