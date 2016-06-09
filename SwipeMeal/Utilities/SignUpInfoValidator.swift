//
//  SignUpInfoValidator.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

enum SignUpInfoInvalidStatus
{
   case FirstNameEmpty, LastNameEmpty, EmailEmpty, InvalidEmail(email: String), PasswordEmpty, PasswordsDoNotMatch, InvalidUniversityEmail(university: String, email: String)
   
   private func valid(info: SignUpInfo) -> Bool {
      switch self {
      case .FirstNameEmpty: return info.firstName != ""
      case .LastNameEmpty: return info.lastName != ""
      case .EmailEmpty: return info.email != ""
      case .InvalidEmail(_): return info.email.isValidEmail
      case .PasswordEmpty: return info.password != ""
      case .PasswordsDoNotMatch: return info.password == info.confirmedPassword
      case .InvalidUniversityEmail(_, _): return info.email.isUniversityEmail // For now
      }
   }
   
   private static func status(info: SignUpInfo) -> SignUpInfoInvalidStatus?
   {
      var invalidStatus: SignUpInfoInvalidStatus?
      for status in SignUpInfoInvalidStatus.all(info) {
         if !status.valid(info) {
            invalidStatus = status
            break
         }
      }
      return invalidStatus
   }
   
   private static func all(info: SignUpInfo) -> [SignUpInfoInvalidStatus]
   {
      return [
         .FirstNameEmpty,
         .LastNameEmpty,
         .EmailEmpty,
         .InvalidEmail(email: info.email),
         .PasswordEmpty,
         .PasswordsDoNotMatch,
         .InvalidUniversityEmail(university: "", email: info.email)
      ]
   }
   
   var title: String {
      switch self {
      case .FirstNameEmpty: return "Invalid First Name"
      case .LastNameEmpty: return "Invalid Last Name"
      case .EmailEmpty: return "Invalid Email"
      case .InvalidEmail(_): return "Invalid Email"
      case .PasswordEmpty: return "Invalid Password"
      case .PasswordsDoNotMatch: return "Incorrect Confirmed Password"
      case .InvalidUniversityEmail(_, _): return "Unsupported Univerity Email"
      }
   }
   
   var errorMessage: String {
      switch self {
      case .FirstNameEmpty: return "The First Name field is empty. Please enter your first name."
      case .LastNameEmpty: return "The Last Name field is empty. Please enter your last name."
      case .EmailEmpty: return "The E-mail field is empty. Please enter your email address"
      case .InvalidEmail(let email): return "\(email) is not a valid email address. Please enter a valid email address."
      case .PasswordEmpty: return "The Password field is empty. Please enter a password."
      case .PasswordsDoNotMatch: return "The Password and Confirmed Password fields do not match."
      case .InvalidUniversityEmail(_, let email): return "The email address \(email) is not a valid university email."
      }
   }
}

struct SignUpInfoValidator
{
   let info: SignUpInfo
   
   func validate() -> SignUpInfoInvalidStatus?
   {
      return SignUpInfoInvalidStatus.status(info)
   }
}