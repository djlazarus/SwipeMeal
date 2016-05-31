//
//  AppDelegate.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import Firebase
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
   var window: UIWindow?
   
   // MARK: - Overridden
   func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
   {
      _registerForPushNotifications(application)
      FIRApp.configure()
      
      _observeFirebaseMessagingTokenRefresh()
      _setupRootViewController()
      
      let token = FIRInstanceID.instanceID().token()
      print("TOKEN: \(token)")
      
      return true
   }
   
   func applicationDidBecomeActive(application: UIApplication)
   {
      _connectToFCM()
   }
   
   func applicationDidEnterBackground(application: UIApplication)
   {
      FIRMessaging.messaging().disconnect()
   }
   
   func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings)
   {
      if notificationSettings.types != .None {
         application.registerForRemoteNotifications()
      }
   }
   
   func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
   {
      let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
      var tokenString = ""
      
      for i in 0..<deviceToken.length {
         tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
      }
      
      FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Sandbox)
      print("Device Token:", tokenString)
   }
   
   func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
   {
      print("Failed to register for remote notifications: \(error.description)")
   }
   
   func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
   {
      FIRMessaging.messaging().appDidReceiveMessage(userInfo)
      
      print("Message ID: \(userInfo["gcm.message_id"]!)")
      print(userInfo)
      
      completionHandler(.NoData)
   }
   
   // MARK: - Private
   private func _registerForPushNotifications(application: UIApplication)
   {
      let notificationSettings = UIUserNotificationSettings(
         forTypes: [.Badge, .Sound, .Alert], categories: nil)
      application.registerUserNotificationSettings(notificationSettings)
   }
   
   private func _setupRootViewController()
   {
      let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
      let controller = storyboard.instantiateViewControllerWithIdentifier("WelcomeViewControllerID")
      
      window = UIWindow()
      window?.rootViewController = controller
      window?.makeKeyAndVisible()
   }
   
   private func _connectToFCM()
   {
      FIRMessaging.messaging().connectWithCompletion { (error) in
         
         if let error = error {
            print("Could not connect to FCM: \(error.description)")
         }
         else {
            print("Connected to FCM successfully.")
         }
      }
   }
   
   // MARK: - Observing
   private func _observeFirebaseMessagingTokenRefresh()
   {
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.tokenRefreshed(_:)), name: kFIRInstanceIDTokenRefreshNotification, object: nil)
   }
   
   internal func tokenRefreshed(notification: NSNotification)
   {
      let refreshedToken = FIRInstanceID.instanceID().token()!
      print("InstanceID token: \(refreshedToken)")
      
      _connectToFCM()
   }
}