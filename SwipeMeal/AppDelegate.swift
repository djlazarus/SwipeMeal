//
//  AppDelegate.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import Firebase
import Branch
import Stripe
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
   var window: UIWindow?
   fileprivate let _flowController = AppEntryFlowController()
   
   // MARK: - Overridden
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
   {
//      _registerForPushNotifications(application)
      FIRApp.configure()
		
		FIRDatabase.database().persistenceEnabled = true
      OneSignal.initWithLaunchOptions(launchOptions, appId: "71319fb8-f6ae-45f6-ba32-ad7f39a39d79")
		
//      _observeFirebaseMessagingTokenRefresh()
		
      _setupRootViewController()
		_setupNavBarAppearance()
		
		let branch = Branch.getInstance()
		branch?.initSession(launchOptions: launchOptions) { (branchUniversalObject, branchLinkProperties, error) in
			let metadata = branchUniversalObject.metadata
			if metadata != nil {
				if let referralSenderID = metadata?["referral_sender_uid"] as? String {
					print("--- BRANCH.IO --- Referral: \(referralSenderID)")
					SwipeMealUserStorage.referralUID = referralSenderID
				}
			}
		}
		
//      let token = FIRInstanceID.instanceID().token()
//      print("TOKEN: \(token)")
		
    // Stripe setup
    STPPaymentConfiguration.shared().publishableKey = "pk_live_nZpTMAMiiErZUdkUOEDI88LP"
    STPTheme.default().accentColor = UIColor(hexString: "6BB739");
    STPTheme.default().secondaryForegroundColor = UIColor(hexString: "6BB739");
		
    return true
   }
	
	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		return Branch.getInstance().handleDeepLink(url)
	}
	
	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
		return Branch.getInstance().continue(userActivity)
	}
   
//   func applicationDidBecomeActive(application: UIApplication)
//   {
//      _connectToFCM()
//   }
		
//   func applicationDidEnterBackground(application: UIApplication)
//   {
//      FIRMessaging.messaging().disconnect()
//   }
		
   func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings)
   {
      if notificationSettings.types != UIUserNotificationType() {
         application.registerForRemoteNotifications()
      }
   }
   
//   func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
//   {
//      let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
//      var tokenString = ""
//      
//      for i in 0..<deviceToken.length {
//         tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
//      }
//      
//      FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Sandbox)
//		SwipeMealPushStorage.deviceToken = tokenString
//      print("Device Token:", tokenString)
//   }
	
//   func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
//   {
//      print("Failed to register for remote notifications: \(error.description)")
//   }
	
//   func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
//   {
//      FIRMessaging.messaging().appDidReceiveMessage(userInfo)
//      
//      print("Message ID: \(userInfo["gcm.message_id"])")
//      print(userInfo)
//		
//      completionHandler(.NoData)
//   }
	
   // MARK: - Private
   fileprivate func _setupRootViewController()
   {
      window = UIWindow()
      window?.rootViewController = _flowController.initialViewController()
      window?.makeKeyAndVisible()
   }
	
	fileprivate func _setupNavBarAppearance()
	{
		let barButtonItemAppearance = UIBarButtonItem.appearance()
		
		let primaryColor = UIColor.white
		barButtonItemAppearance.tintColor = primaryColor
		barButtonItemAppearance.setTitleTextAttributes([NSForegroundColorAttributeName : primaryColor], for: UIControlState())
		barButtonItemAppearance.setTitleTextAttributes([NSForegroundColorAttributeName : primaryColor.withAlphaComponent(0.4)], for: .disabled)
		
		let navBarAppearance = UINavigationBar.appearance()
		navBarAppearance.tintColor = UIColor.white
	}
	
//   private func _registerForPushNotifications(application: UIApplication)
//   {
//      let notificationSettings = UIUserNotificationSettings(
//         forTypes: [.Badge, .Sound, .Alert], categories: nil)
//      application.registerUserNotificationSettings(notificationSettings)
//   }
	
//   private func _connectToFCM()
//   {
//      FIRMessaging.messaging().connectWithCompletion { (error) in
//         if let error = error {
//            print("Could not connect to FCM: \(error.description)")
//         } else {
//            print("Connected to FCM successfully.")
//         }
//      }
//   }
	
   // MARK: - Observing
//   private func _observeFirebaseMessagingTokenRefresh()
//   {
//      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.tokenRefreshed(_:)), name: kFIRInstanceIDTokenRefreshNotification, object: nil)
//   }
//   
//   internal func tokenRefreshed(notification: NSNotification)
//   {
//      let refreshedToken = FIRInstanceID.instanceID().token()
//		SwipeMealPushStorage.instanceIDToken = refreshedToken
//      print("InstanceID token: \(refreshedToken)")
//		
//      _connectToFCM()
//   }
}
