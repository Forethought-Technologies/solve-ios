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
            
            //are we in a navigation controller?
            if let navigationController = self.forethoughtVC?.navigationController {
                //show through navigation
                ForethoughtSDK.hide(animated: true) {
                    navigationController.pushViewController(viewController, animated: true)
                }
            } else {
                //present on the window
                ForethoughtSDK.hide(animated: true) {
                    self.presentModally(viewController: viewController)
                }
            }
            ForethoughtSDK.sendHandoffResponse(success: true)
        }
        catch {
            print("FT - Could not initiate Zendesk chat")
            ForethoughtSDK.sendHandoffResponse(success: false)
        }
    }
    
    /// Presents the Zendesk screen modally instead of via a Navigation controller.
    /// This is used based on if the Forethought screen was shown via Navigation, or Modally.
    func presentModally(viewController: UIViewController) {
        if #available(iOS 13, *) {
            let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
            if let rootVC = window?.rootViewController {
                rootVC.present(viewController, animated: true, completion: nil)
            }
        } else {
            let window = UIApplication.shared.keyWindow
            if let rootVC = window?.rootViewController {
                rootVC.present(viewController, animated: true, completion: nil)
            }
        }
    }
}
