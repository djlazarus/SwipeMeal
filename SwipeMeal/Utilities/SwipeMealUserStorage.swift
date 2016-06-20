//
//  SwipeMealUserStorage.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

private enum SwipeMealUserStorageKey: String
{
   case ProfileSetupComplete
   
   func keyName(user: SwipeMealUser) -> String {
      return "\(user.uid)-\(self)"
   }
}

struct SwipeMealUserStorage
{
   let user: SwipeMealUser
   
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
}
