//
//  CreateStripeAccountOperation.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 9/8/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import SwiftSpinner

class CreateStripeAccountOperation: BaseOperation {
	
	let _user: SwipeMealUser
	
	init(user: SwipeMealUser) {
		_user = user
		super.init()
	}
	
	override func execute() {
		guard let email = _user.email else { //, let ipAddress = getIFAddresses().first else {
			error = _stripeAccountCreationError() as NSError?
			finish()
			return
		}
		
		let service = StripePaymentService.shared()
		guard let ipAddress = service?.getIPAddress(false) else {
			error = _stripeAccountCreationError() as NSError?
			finish()
			return
		}
		
		SwiftSpinner.show("Creating Account...")
		print("creating account for: \(email), with ipAddress: \(ipAddress)")
		service?.createCustomer(withUserID: _user.uid, email: email, ipAddress: ipAddress) { (info, error) in
			if error != nil {
				self.error = error as NSError?
			}
			
			SwiftSpinner.hide()
			self.finish()
		}
	}
	
	private func _stripeAccountCreationError() -> Error {
		
		let info = [
			NSLocalizedDescriptionKey : "Could not create stripe account.",
			NSLocalizedFailureReasonErrorKey : "Could not obtain the required information for creating a Stripe account.",
			NSLocalizedRecoverySuggestionErrorKey : "Try again later."
		]
		
		return NSError(domain: "SwipeMealErrorDomain", code: 6666, userInfo: info)
	}
}
