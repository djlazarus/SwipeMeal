//
//  SwipeMealUserStorage.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

private enum SwipeMealUserStorageKey: String
{
   case ProfileSetupComplete
   
   func keyName(user: SwipeMealUser) -> String {
      return "\(user.uid)-\(self)"
   }
}

class SwipeMealUserStorage: NSObject
{
   let user: SwipeMealUser
	
	init(user: SwipeMealUser) {
		self.user = user
		super.init()
	}
   
   var profileSetupComplete: Bool {
      get {
         let defaults = NSUserDefaults.standardUserDefaults()
         let key = SwipeMealUserStorageKey.ProfileSetupComplete.keyName(user)
         return defaults.boolForKey(key)
      }
      set {
         let defaults = NSUserDefaults.standardUserDefaults()
         let key = SwipeMealUserStorageKey.ProfileSetupComplete.keyName(user)
         defaults.setBool(newValue, forKey: key)
      }
	}
	
	static var referralUID: String? {
		get {
			return Defaults[.referralUID]
		}
		set {
			Defaults[.referralUID] = newValue
		}
	}
	
	static var hasMadeFirstPurchaseOrSale: Bool {
		get {
			return Defaults[.hasMadeFirstPurchaseOrSale]
		}
		set {
			Defaults[.hasMadeFirstPurchaseOrSale] = newValue
		}
	}
}

struct SwipeMealPushStorage {
	static var deviceToken: String? {
		get {
			return Defaults[.deviceToken]
		}
		set {
			Defaults[.deviceToken] = newValue
		}
	}
	
	static var instanceIDToken: String? {
		get {
			return Defaults[.instanceIDToken]
		}
		set {
			Defaults[.instanceIDToken] = newValue
		}
	}
	
	static var oneSignalPlayerID: String? {
		get {
			return Defaults[.oneSignalPlayerID]
		}
		set {
			Defaults[.oneSignalPlayerID] = newValue
		}
	}
}

extension DefaultsKeys {
	static let oneSignalPlayerID = DefaultsKey<String?>("com.SwipeMeal.oneSignalPlayerID")
	static let deviceToken = DefaultsKey<String?>("com.SwipeMeal.deviceToken")
	static let instanceIDToken = DefaultsKey<String?>("com.SwipeMeal.instanceIDToken")
	static let referralUID = DefaultsKey<String?>("com.SwipeMeal.referralUID")
	static let hasMadeFirstPurchaseOrSale = DefaultsKey<Bool>("com.SwipeMeal.hasMadeFirstPurchaseOrSale")
}