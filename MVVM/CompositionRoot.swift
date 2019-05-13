//
//  CompositionRoot.swift
//  MVVM
//
//  Created by 张坤 on 2019/5/5.
//  Copyright © 2019 ripple_k. All rights reserved.
//

import UIKit

public struct AppDependency {
    public let window: UIWindow
    public let configureSDKs: () -> Void
    public let configureAppearance: () -> Void
    public let configurePreferences: () -> Void
}

public final class CompositionRoot {
    /// Builds a dependency graph and returns an entry view controller.
    public static func resolve() -> AppDependency {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let homepageVC = HomepageViewController()
        homepageVC.reactor = HomepageViewReactor()
        window.rootViewController =
            UINavigationController(rootViewController: homepageVC)
        window.makeKeyAndVisible()
        
        return AppDependency(window: window,
                             configureSDKs: self.configureSDKs,
                             configureAppearance: self.configureAppearance,
                             configurePreferences: self.configurePreferences
        )
    }
    
    
    /// ConfigureSDKs for App
    static func configureSDKs() {
        
    }
    
    /// ConfigureAppearance for App
    static func configureAppearance() {
        
    }
    
    /// ConfigurePreferences for App
    static func configurePreferences() {
        
    }
}


