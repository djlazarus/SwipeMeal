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
	
	var groupID: String? { get }
   
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
   
   /** @property emailVerified
    @brief Indicates the email address associated with this user has been verified.
    */
   var emailVerified: Bool { get }
   
   var profileSetupComplete: Bool { get }
	
	func updatePhotoURL(url: NSURL, completion: UpdateUserProfileCompletion?)
	func updateDisplayName(name: String, completion: UpdateUserProfileCompletion?)
	
   func reload(completion: ReloadUserProfileCompletion?)
   func sendEmailVerification(completion: SendEmailVerificationCompletion?)
	
	func signOut()
}

extension SwipeMealUser {
	var groupID: String? {
		guard let email = email else { return nil }
		guard let lastComponent = email.componentsSeparatedByString("@").last else { return nil }
		return lastComponent.stringByReplacingOccurrencesOfString(".", withString: "-")
	}
	
	func rate(userWithUID uid: String, value: Int) {
		SMDatabaseLayer.add(rating: value, toUserWithUID: uid, fromUserWithUID: self.uid)
	}
}