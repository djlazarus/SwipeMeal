//
//  Firebase+SwipeMeal.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import FirebaseAuth

extension FIRUser: SwipeMealUser
{	
   var profileSetupComplete: Bool {
      let storage = SwipeMealUserStorage(user: self)
      return storage.profileSetupComplete
   }
   
   func reload(completion: ReloadUserProfileCompletion?)
   {
      reloadWithCompletion(completion)
   }
   
   func sendEmailVerification(completion: SendEmailVerificationCompletion?)
   {
      sendEmailVerificationWithCompletion(completion)
   }
	
	func updatePhotoURL(photoURL: NSURL, completion: UpdateUserProfileCompletion?)
	{
		let changeRequest = profileChangeRequest()
		
		changeRequest.photoURL = photoURL
		changeRequest.commitChangesWithCompletion(completion)
	}
	
	func updateDisplayName(name: String, completion: UpdateUserProfileCompletion?)
	{
		let changeRequest = profileChangeRequest()
		changeRequest.displayName = name
		
		changeRequest.commitChangesWithCompletion(completion)
	}
}
