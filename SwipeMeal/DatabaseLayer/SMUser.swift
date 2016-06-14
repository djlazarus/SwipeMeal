//
//  SMUser.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

protocol SwipeMealUser
{
   var providerID: String { get }
   
   /** @property uid
    @brief The provider's user ID for the user.
    */
   var uid: String { get }
   
   /** @property displayName
    @brief The name of the user.
    */
   var displayName: String? { get }
   
   /** @property photoURL
    @brief The URL of the user's profile photo.
    */
   var photoURL: NSURL? { get }
   
   /** @property email
    @brief The user's email address.
    */
   var email: String? { get }
   
   func reload(completion: ReloadUserProfileCompletion?)
   func sendEmailVerification(completion: SendEmailVerificationCompletion?)
}
