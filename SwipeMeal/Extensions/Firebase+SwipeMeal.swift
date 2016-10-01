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
   
   func reload(_ completion: ReloadUserProfileCompletion?)
   {
      self.reload(completion: completion)
   }
   
   func sendEmailVerification(_ completion: SendEmailVerificationCompletion?)
   {
      self.sendEmailVerification(completion: completion)
   }
	
	func updatePhotoURL(_ photoURL: URL, completion: UpdateUserProfileCompletion?)
	{
		let changeRequest = profileChangeRequest()
		
		changeRequest.photoURL = photoURL
		changeRequest.commitChanges(completion: completion)
	}
	
	func updateDisplayName(_ name: String, completion: UpdateUserProfileCompletion?)
	{
		let changeRequest = profileChangeRequest()
		changeRequest.displayName = name
		
		changeRequest.commitChanges(completion: completion)
	}
	
	func signOut() {
		do {
			try FIRAuth.auth()?.signOut()
		} catch {
		}
	}
}
