//
//  ZendeskPlugin.swift
//  Plugins
//
//  Created by Matthew Knippen on 2/18/22.
//

import ChatSDK
import ChatProvidersSDK
import Forethought
import MessagingSDK
import UIKit

/// A plugin for connecting Forethought Solve with Zendesk
public class ZendeskPlugin: ForethoughtPlugin {
    /// The integration name that connects Zendesk to Forethought. This should not be altered.
    public var pluginName = "zendesk"
    
    /// A link to the Forethought View Controller, if needed to send messages back to Forethought
    weak var forethoughtVC: UIViewController?
    
    
    /// Configures the Zendesk SDK and attaches it directly to Forethought
    ///
    ///  - Parameters:
    ///    - accountKey: Your Zendesk account key
    ///    - appId: Your Zendesk Application ID
    public init(accountKey: String, appId: String) {
        Chat.initialize(accountKey: accountKey, appId: appId)
    }
    
    /// Required for the ForethoughtPlugin Protocol. Chooses to show the Zendesk Plugin instead of Forethought. Defaults to false
    public func showPluginOnLaunch() -> Bool {
        return false
    }
    
    /// Required for the ForethoughtPlugin Protocol. Sets the Viewcontroller for Forethought
    public func forethoughtViewLoaded(viewController: UIViewController) {
        self.forethoughtVC = viewController
    }
    
    /// Required for the ForethoughtPlugin Protocol. Informs the plugin that Forethought would like to handoff to Zendesk.
    /// Manages passing in the Forethought handoff data, dismissing Forethought, and showing presenting the Zendesk screen
    public func forethoughtHandoffRequested(handoffData: ForethoughtHandoffData) {
        do {
            // Configure Zendesk Widget
            let messagingConfiguration = MessagingConfiguration()
            let chatConfiguration = ChatConfiguration()
            chatConfiguration.isPreChatFormEnabled = false
            chatConfiguration.isAgentAvailabilityEnabled = false
          
            // update Chat instance
            let chatAPIConfiguration = ChatAPIConfiguration()
            chatAPIConfiguration.visitorInfo = VisitorInfo(name: handoffData.name ?? "", email: handoffData.email ?? "", phoneNumber: "")
            Chat.instance?.configuration = chatAPIConfiguration
          
            // send question
            if let question = handoffData.question {
                Chat.connectionProvider?.connect()
                Chat.chatProvider?.sendMessage(question)
                Chat.connectionProvider?.disconnect()
            }
            
            // Build and present Zendesk Chat
            let chatEngine = try ChatEngine.engine()
            let viewController = try Messaging.instance.buildUI(engines: [chatEngine], configs: [messagingConfiguration, chatConfiguration])
//            self.navigationController?.pushViewController(viewController, animated: true)
            
            // Are we in a navigation controller?
            if let navigationController = self.forethoughtVC?.navigationController {
                //show through navigation. Since there's a navigate back, and then forward, it's better without animation
                ForethoughtSDK.hide(animated: false) {
                    navigationController.pushViewController(viewController, animated: false)
                }
            } else {
                //Zendesk needs to be inside of a NavigationController. If we don't have one, let's create it
                let navigationController = self.setupNavigationController(rootViewController: viewController)
                ForethoughtSDK.hide(animated: true) {
                    //present on the window
                    self.presentModally(viewController: navigationController)
                }
            }
            ForethoughtSDK.sendHandoffResponse(success: true)
        }
        catch {
            print("FT - Could not initiate Zendesk chat")
            ForethoughtSDK.sendHandoffResponse(success: false)
        }
    }
    
    // Zendesk needs to be inside of a NavigationController. If we don't have one, let's create it
    // We should also add a done button so they can exit the flow
    private func setupNavigationController(rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ZendeskPlugin.closeModal))
        rootViewController.navigationItem.leftBarButtonItem = doneButton
        return navigationController
    }
    
    /// Presents the Zendesk screen modally instead of via a Navigation controller.
    /// This is used based on if the Forethought screen was shown via Navigation, or Modally.
    private func presentModally(viewController: UIViewController) {
        if let rootVC = self.getRootViewController() {
            rootVC.present(viewController, animated: true, completion: nil)
        }
    }
    
    // Closes the modal
    @objc private func closeModal() {
        if let rootVC = self.getRootViewController() {
            rootVC.dismiss(animated: true)
        }
    }
    
    // Gets the Root View Controller of the app to present a modal on top of it
    private func getRootViewController() -> UIViewController? {
        if #available(iOS 13, *) {
            let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
            return window?.rootViewController
        } else {
            let window = UIApplication.shared.keyWindow
            return window?.rootViewController

        }
    }
}
