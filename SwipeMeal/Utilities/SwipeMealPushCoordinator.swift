//
//  SwipeMealPushCoordinator.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 9/12/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import OneSignal
import FirebaseAuth

class SwipeMealPushCoordinator: NSObject {
	
	static func notifyUserOfInterestInPurchase(_ userUID: String) {
		guard let currentUser = FIRAuth.auth()?.currentUser else { return }
		
		SMDatabaseLayer.getOneSignalPlayerID(forUserWithUID: userUID) { (oneSignalPlayerID) in
			guard let playerID = oneSignalPlayerID else { return }
			
			let name = currentUser.displayName ?? "A user"
			OneSignal.postNotification([
				"contents": ["en": "\(name) is interested in buying your Swipe!"],
				"include_player_ids": [playerID]]
			)
		}
	}
	
	static func notifyUserOfArrival(_ userUID: String) {
		SMDatabaseLayer.getOneSignalPlayerID(forUserWithUID: userUID) { (oneSignalPlayerID) in
			guard let currentUser = FIRAuth.auth()?.currentUser else { return }
			guard let playerID = oneSignalPlayerID else { return }
			
			let name = currentUser.displayName ?? "A user"
			OneSignal.postNotification([
				"contents": ["en": "\(name) has arrived at the location."],
				"include_player_ids": [playerID]]
			)
		}
	}
}
