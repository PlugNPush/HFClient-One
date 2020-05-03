//
//  AppDelegate.swift
//  HiberLink
//
//  Created by Nathan FALLET on 19/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

#if targetEnvironment(macCatalyst)
extension AppDelegate {
    
    override func buildMenu(with builder: UIMenuBuilder) {
        // Check if it's main menu
        if builder.system == .main {
            // Help feature
            builder.replaceChildren(ofMenu: .help, from: helpMenu(elements:))
        }
    }
    
    func helpMenu(elements: [UIMenuElement]) -> [UIMenuElement] {
        // Create a menu item
        let help = UIKeyCommand(title: "help".localized(), image: nil, action: #selector(openHelp(_:)), input: "?", modifierFlags: .command, propertyList: nil, alternates: [], discoverabilityTitle: nil, attributes: .destructive, state: .off)
        
        // Return list
        return [help]
    }
    
    @objc func openHelp(_ sender: Any) {
        // Help and documentation
        if let url = URL(string: "https://www.hiberfile.com") {
            UIApplication.shared.open(url)
        }
    }

}
#endif

