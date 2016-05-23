//
//  AppDelegate.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 5/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
   var window: UIWindow?
   
   // MARK: - Overridden
   func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
   {
      FIRApp.configure()
      _setupRootViewController()
      
      return true
   }
   
   func applicationWillResignActive(application: UIApplication)
   {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   }
   
   func applicationDidEnterBackground(application: UIApplication)
   {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   }
   
   func applicationWillEnterForeground(application: UIApplication)
   {
      // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   }
   
   func applicationDidBecomeActive(application: UIApplication)
   {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   }
   
   func applicationWillTerminate(application: UIApplication)
   {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   }
   
   // MARK: - Private
   private func _setupRootViewController()
   {
      let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
      let controller = storyboard.instantiateViewControllerWithIdentifier("ViewControllerID")
      
      let navController = UINavigationController(rootViewController: controller)
      navController.navigationBar.barStyle = .Black
      navController.navigationBar.tintColor = UIColor.redColor()
      navController.navigationBar.translucent = false
      
      let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Organize, target: nil, action: nil)
      
      let rightItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: nil, action: nil)
      
      controller.navigationItem.leftBarButtonItem = leftItem
      controller.navigationItem.rightBarButtonItem = rightItem
      
      window = UIWindow()
      window?.rootViewController = navController
      window?.makeKeyAndVisible()
   }
}