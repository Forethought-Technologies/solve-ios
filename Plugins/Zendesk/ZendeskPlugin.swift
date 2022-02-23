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

public class ZendeskPlugin: ForethoughtPlugin {
    public var pluginName = "zendesk"
    
    weak var forethoughtVC: UIViewController?
    
    public init(accountKey: String, appId: String) {
        Chat.initialize(accountKey: accountKey, appId: appId)
    }
    
    public func showPluginOnLaunch() -> Bool {
        return false
    }
    
    public func forethoughtViewLoaded(viewController: UIViewController) {
        self.forethoughtVC = viewController
    }
    
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
        }
        catch {
            print("FT - Could not initiate Zendesk chat")
        }
    }
    
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
