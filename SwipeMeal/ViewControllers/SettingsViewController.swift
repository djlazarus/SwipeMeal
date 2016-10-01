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
	
	fileprivate let _legalController = LegalDocumentationViewController.instantiate(fromStoryboard: "SignUp")
	
	override var preferredStatusBarStyle : UIStatusBarStyle {
		return .lightContent
	}
	
	// MARK: - Actions
	@IBAction fileprivate func _referAFriendButtonPressed() {
		guard let referralUserUID = SMAuthLayer.currentUser?.uid else { return }
		
		let linkProperties: BranchLinkProperties = BranchLinkProperties()
		linkProperties.feature = "referrals"
		let universalObject = BranchUniversalObject(title: "Swipemeal")
		universalObject.canonicalIdentifier = "Swipemeal"
		
		universalObject.addMetadataKey("referral_sender_uid", value: referralUserUID)
		universalObject.showShareSheet(with: linkProperties,
		                                                 andShareText: "Download Swipemeal",
		                                                 from: self,
		                                                 completion: nil)
	}
	
	@IBAction fileprivate func _privacyPolicyButtonPressed() {
		_legalController.type = .privacyPolicy
		present(_legalController, animated: true, completion: nil)
	}
	
	@IBAction fileprivate func _termsAndConditionsButtonPressed() {
		_legalController.type = .termsOfUse
		present(_legalController, animated: true, completion: nil)
	}
	
	@IBAction fileprivate func _logOutButtonPressed() {
		dismiss(animated: true) { 
			SMAuthLayer.currentUser?.signOut()
		}
	}
	
	@IBAction fileprivate func _closeButtonPressed() {
		dismiss(animated: true, completion: nil)
	}
}
