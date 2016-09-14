//
//  SettingsViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 9/11/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import Branch

class SettingsViewController: UIViewController {
	
	private let _legalController = LegalDocumentationViewController.instantiate(fromStoryboard: "SignUp")
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	// MARK: - Actions
	@IBAction private func _referAFriendButtonPressed() {
		guard let referralUserUID = SMAuthLayer.currentUser?.uid else { return }
		
		let linkProperties: BranchLinkProperties = BranchLinkProperties()
		linkProperties.feature = "referrals"
		let universalObject = BranchUniversalObject(title: "Swipemeal")
		universalObject.canonicalIdentifier = "Swipemeal"
		
		universalObject.addMetadataKey("referral_sender_uid", value: referralUserUID)
		universalObject.showShareSheetWithLinkProperties(linkProperties,
		                                                 andShareText: "Download Swipemeal",
		                                                 fromViewController: self,
		                                                 completion: nil)
	}
	
	@IBAction private func _privacyPolicyButtonPressed() {
		_legalController.type = .PrivacyPolicy
		presentViewController(_legalController, animated: true, completion: nil)
	}
	
	@IBAction private func _termsAndConditionsButtonPressed() {
		_legalController.type = .TermsOfUse
		presentViewController(_legalController, animated: true, completion: nil)
	}
	
	@IBAction private func _logOutButtonPressed() {
		dismissViewControllerAnimated(true) { 
			SMAuthLayer.currentUser?.signOut()
		}
	}
	
	@IBAction private func _closeButtonPressed() {
		dismissViewControllerAnimated(true, completion: nil)
	}
}
