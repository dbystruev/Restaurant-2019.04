//
//  AppDelegate.swift
//  Restaurant 2019.04
//
//  Created by Denis Bystruev on 09/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var orderTabBarItem: UITabBarItem!
    
    @objc func updateOrderBadge() {
        let count = MenuController.shared.order.menuItems.count
        
        orderTabBarItem.badgeValue = count == 0 ? nil : "\(count)"
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let rootViewController = window!.rootViewController
        let tabBarController = rootViewController as! UITabBarController
        let orderNavigationController = tabBarController.viewControllers![1]
        
        orderTabBarItem = orderNavigationController.tabBarItem
        
        let temporaryDirectory = NSTemporaryDirectory()
        let urlCache = URLCache(memoryCapacity: 25_000_000, diskCapacity: 50_000_000, diskPath: temporaryDirectory)
        URLCache.shared = urlCache
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateOrderBadge),
            name: MenuController.orderUpdatedNotification,
            object: nil
        )
        
        return true
    }
}

