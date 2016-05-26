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
   case FirstNameEmpty, LastNameEmpty, EmailEmpty, PasswordEmpty, PasswordsDoNotMatch, UniversityDoesNotMatchEmail(university: String, email: String)
   
   func valid(info: SignUpInfo) -> Bool {
      switch self {
      case .FirstNameEmpty: return info.firstName != ""
      case .LastNameEmpty: return info.lastName != ""
      case .EmailEmpty: return info.email != ""
      case .PasswordEmpty: return info.password != ""
      case .PasswordsDoNotMatch: return info.password == info.confirmedPassword
      case .UniversityDoesNotMatchEmail(_, _): return true // For now
      }
   }
   
   static let all: [SignUpInfoInvalidStatus] = [
      .FirstNameEmpty,
      .LastNameEmpty,
      .EmailEmpty,
      .PasswordEmpty,
      .PasswordsDoNotMatch,
      .UniversityDoesNotMatchEmail(university: "", email: "")
   ]
   
   func description(info: SignUpInfo) -> String {
      switch self {
      case .FirstNameEmpty: return "First Name is empty"
      case .LastNameEmpty: return "Last Name is empty"
      case .EmailEmpty: return "Email is empty"
      case .PasswordEmpty: return "Password is empty"
      case .PasswordsDoNotMatch: return "Password and Confirmed Password do not match"
      case .UniversityDoesNotMatchEmail(let university, let email):
         return "\(university) doesn't match the \(email) email address"
      }
   }
}

struct SignUpInfoValidator
{
   let info: SignUpInfo
   
   func validate() -> SignUpInfoInvalidStatus?
   {
      var invalidStatus: SignUpInfoInvalidStatus?
      for status in SignUpInfoInvalidStatus.all {
         if !status.valid(info) {
            invalidStatus = status
            break
         }
      }
      return invalidStatus
   }
}