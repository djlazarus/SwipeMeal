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
   case firstNameEmpty, lastNameEmpty, emailEmpty, invalidEmail(email: String), passwordEmpty, passwordsDoNotMatch, invalidUniversityEmail(university: String, email: String)
   
   fileprivate func valid(_ info: SignUpInfo) -> Bool {
      switch self {
      case .firstNameEmpty: return info.firstName != ""
      case .lastNameEmpty: return info.lastName != ""
      case .emailEmpty: return info.email != ""
      case .invalidEmail(_): return info.email.isValidEmail
      case .passwordEmpty: return info.password != ""
      case .passwordsDoNotMatch: return info.password == info.confirmedPassword
      case .invalidUniversityEmail(_, _): return info.email.isUniversityEmail
      }
   }
   
   fileprivate static func status(_ info: SignUpInfo) -> SignUpInfoInvalidStatus?
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
   
   fileprivate static func all(_ info: SignUpInfo) -> [SignUpInfoInvalidStatus]
   {
      return [
         .firstNameEmpty,
         .lastNameEmpty,
         .emailEmpty,
         .invalidEmail(email: info.email),
         .passwordEmpty,
         .passwordsDoNotMatch,
         .invalidUniversityEmail(university: "", email: info.email)
      ]
   }
   
   var title: String {
      switch self {
      case .firstNameEmpty: return "Invalid First Name"
      case .lastNameEmpty: return "Invalid Last Name"
      case .emailEmpty: return "Invalid Email"
      case .invalidEmail(_): return "Invalid Email"
      case .passwordEmpty: return "Invalid Password"
      case .passwordsDoNotMatch: return "Incorrect Confirmed Password"
      case .invalidUniversityEmail(_, _): return "Unsupported Email"
      }
   }
   
   var errorMessage: String {
      switch self {
      case .firstNameEmpty: return "The First Name field is empty. Please enter your first name."
      case .lastNameEmpty: return "The Last Name field is empty. Please enter your last name."
      case .emailEmpty: return "The E-mail field is empty. Please enter your email address"
      case .invalidEmail(let email): return "\(email) is not a valid email address. Please enter a valid email address."
      case .passwordEmpty: return "The Password field is empty. Please enter a password."
      case .passwordsDoNotMatch: return "The Password and Confirmed Password fields do not match."
      case .invalidUniversityEmail(_, let email): return "The email address \(email) is not a valid university email."
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
