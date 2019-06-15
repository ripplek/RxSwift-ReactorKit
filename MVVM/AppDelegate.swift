//
//  AppDelegate.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/5.
//  Copyright © 2019 ripple_k. All rights reserved.
// swiftlint:disable line_length

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var dependency: AppDependency!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        dependency = dependency ?? CompositionRoot.resolve()
        dependency.configureSDKs()
        dependency.configureAppearance()
        dependency.configurePreferences()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

}
