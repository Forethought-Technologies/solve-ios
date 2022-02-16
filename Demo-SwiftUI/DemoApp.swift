//
//  DemoApp.swift
//  Demo
//
//  Created by Matthew Knippen on 12/7/21.
//

import SwiftUI

@main
struct DemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
