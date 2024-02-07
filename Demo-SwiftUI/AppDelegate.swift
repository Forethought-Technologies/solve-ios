//
//  AppDelegate.swift
//  Demo-SwiftUI
//
//  Created by Matthew Knippen on 2/10/22.
//

import Forethought
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, ForethoughtDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        ForethoughtSDK.start(apiKey: "__YOUR_KEY_HERE__")
        return true
    }

    func startChatRequested(handoffData: ForethoughtHandoffData) {
        // do something

        ForethoughtSDK.hide(animated: true) {
            ForethoughtSDK.sendHandoffResponse(success: true)
        }
    }
}
