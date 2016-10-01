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
   func signUpViewControllerSignInButtonPressed(_ controller: SignUpViewController)
   func signUpViewControllerRegisterButtonPressed(_ controller: SignUpViewController)
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
   fileprivate var _initialKeyboardAvoidingConstant: CGFloat = 0
   
   // MARK: - Outlets
   @IBOutlet fileprivate var _firstNameTextField: SignUpTextField!
   @IBOutlet fileprivate var _lastNameTextField: SignUpTextField!
   @IBOutlet fileprivate var _emailTextField: SignUpTextField!
   @IBOutlet fileprivate var _passwordTextField: SignUpTextField!
   @IBOutlet fileprivate var _confirmPasswordTextField: SignUpTextField!
   
   @IBOutlet fileprivate var _textFieldsContainer: UIView!
   @IBOutlet fileprivate var _textFields: [UITextField]!
   @IBOutlet fileprivate var _lastTextField: UITextField!
   
   @IBOutlet fileprivate var _keyboardAvoidingConstraint: NSLayoutConstraint! {
      didSet {
         _initialKeyboardAvoidingConstant = _keyboardAvoidingConstraint.constant
      }
   }
	
	fileprivate let _legalController = LegalDocumentationViewController.instantiate(fromStoryboard: "SignUp")
   
   // MARK: - Computed Properties
   fileprivate var _activeTextField: UITextField? {
      return _textFields.filter({ $0.isFirstResponder }).first
   }
   
   fileprivate var _keyboardPadding: CGFloat {
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
   
   override var preferredStatusBarStyle : UIStatusBarStyle {
      return .lightContent
   }
   
   // MARK: - Setup / Teardown
   fileprivate func _subscribeForKeyboardNotifications()
   {
      let center = NotificationCenter.default
      center.addObserver(self, selector: #selector(SignUpViewController.keyboardWillChangeHeight(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
   }
   
   fileprivate func _unsubscribeFromKeyboardNotifications()
   {
      let center = NotificationCenter.default
      center.removeObserver(self)
   }
   
   // MARK: - Actions
   @IBAction fileprivate func _signInButtonPressed() {
      delegate?.signUpViewControllerSignInButtonPressed(self)
   }
   
   @IBAction fileprivate func _registerButtonPressed() {
      delegate?.signUpViewControllerRegisterButtonPressed(self)
   }
	
	@IBAction fileprivate func _termsOfUsePressed() {
		_legalController.type = .termsOfUse
		present(_legalController, animated: true, completion: nil)
	}
	
	@IBAction fileprivate func _privacyPolicyPressed() {
		_legalController.type = .privacyPolicy
		present(_legalController, animated: true, completion: nil)
	}
   
   // MARK: - Gesture Recognizers
   @IBAction fileprivate func _viewTapped(_ recognizer: UIGestureRecognizer)
   {
      let location = recognizer.location(in: _textFieldsContainer)
      
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
   fileprivate func _resignAllTextFields()
   {
      _textFields.forEach { field in
         field.resignFirstResponder()
      }
   }
   
   fileprivate func _nextTextField(_ field: UITextField) -> UITextField?
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
   internal func keyboardWillChangeHeight(_ notification: Notification)
   {
      guard let userInfo = (notification as NSNotification).userInfo else { return }
      guard let frameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else { return }
      
      let convertedFrameEnd = view.convert(frameEnd, from: nil)
      
      var textFieldFrame = CGRect.zero
      if let frame = _activeTextField?.frame {
         textFieldFrame = _textFieldsContainer.convert(frame, to: nil)
      }

      var offset = (textFieldFrame.maxY + _keyboardPadding) - convertedFrameEnd.minY + _keyboardAvoidingConstraint.constant
      offset = max(offset, _initialKeyboardAvoidingConstant)
      
      _keyboardAvoidingConstraint.constant = offset
      
      guard let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as AnyObject).uint32Value else { return }
      guard let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
      let options = UIViewAnimationOptions(rawValue: UInt(curve) << 16)
      
      UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
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
   func textFieldShouldReturn(_ textField: UITextField) -> Bool
   {
      _nextTextField(textField)?.becomeFirstResponder()
      if textField == _lastTextField {
         textField.resignFirstResponder()
      }
      
      return true
   }
}
