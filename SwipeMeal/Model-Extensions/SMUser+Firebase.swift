//
//  SMUser+Firebase.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import FirebaseAuth

extension SMUser
{
   init?(user: FIRUser)
   {
      guard let email = user.email else { return nil }
      guard let displayName = user.displayName else { return nil }
      guard let photoURL = user.photoURL else { return nil }
      
      self.init(uid: user.uid, email: email, displayName: displayName, photoURL: photoURL)
   }
}