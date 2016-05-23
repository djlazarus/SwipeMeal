//
//  ViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import FirebaseAuth

private let kTestEmail = "gregoryhklein@gmail.com"
private let kTestPassword = "Elleven7"

class ViewController: UIViewController
{
   var loggedInUser: FIRUser?
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
   }
   
   @IBAction private func _deleteUser()
   {
      guard let user = loggedInUser else { return }
      user.deleteWithCompletion { (error) in
         print(error)
      }
   }
   
   @IBAction private func _signUp()
   {
      FIRAuth.auth()?.createUserWithEmail(kTestEmail, password: kTestPassword, completion: { (user, error) in
         if let error = error {
            print(error)
         }
         else {
            print(user)
         }
         self.loggedInUser = user
      })
   }
   
   @IBAction private func _sendVerificationEmail()
   {
      guard let user = loggedInUser else { return }
      user.sendEmailVerificationWithCompletion { (error) in
         print(error)
      }
   }
   
   @IBAction private func _reload()
   {
      guard let user = loggedInUser else { return }
      user.reloadWithCompletion { (error) in
         print(error)
      }
   }
   
   @IBAction private func _signIn()
   {
      FIRAuth.auth()?.signInWithEmail(kTestEmail, password: kTestPassword, completion: { (user, error) in
         if let error = error {
            print(error)
         }
         else {
            print(user)
         }
         
         self.loggedInUser = user
      })
   }
   
   @IBAction private func _printEmailVerifiedStatus()
   {
      guard let user = loggedInUser else { return }
      print("email verified: \(user.emailVerified)")
   }
}