//
//  AppDelegate.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 23/09/20.
//

import UIKit
import Firebase
import FBSDKCoreKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        FirebaseApp.configure()
        _ = Firestore.firestore()
        _ = Storage.storage()
        
        print("Closer en App delegate: \(AlarmsNewUserViewController.closest)")
        IQKeyboardManager.shared.enable = true
        
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // This function will be called right after user tap on the notification
}
