//
//  IntercomPlugin.swift
//  Plugins
//
//  Created by Matthew Knippen on 10/5/22.
//

//  IMPORTANT NOTE: In order to use Intercom, they require a user login.
//  Please use either the Intercom.loginUser(with: ICMUserAttributes) or Intercom.loginUnidentifiedUser method before calling Forethought.show method


import Forethought
import Intercom
import UIKit

/// When Intercom has an open or unread conversation, choose what you would like to happen when the user asks for support
public enum IntercomResumeConversationSetting {
    /// Default. Even if there is an open or unread message, always launch Forethought
    case alwaysStartNewConversation
    /// If there's an unread message from an agent, show it. If there's an open conversation, prompt them
    case showForUnreadMessage
}

/// A plugin for connecting Forethought Solve with Intercom
public class IntercomPlugin: ForethoughtPlugin {
    /// The integration name that connects Intercom to Forethought. This should not be altered.
    public var pluginName = "intercom"
    
    /// A link to the Forethought View Controller, if needed to send messages back to Forethought
    weak var forethoughtVC: UIViewController?
    
    /// When Intercom has an unread conversation, choose what you would like to happen when the user asks for support.
    /// Default is .alwaysStartNewConversation
    public var resumeSetting: IntercomResumeConversationSetting = .alwaysStartNewConversation
    
    /// Configures the Intercom SDK and attaches it directly to Forethought
    ///
    ///  - Parameters:
    ///    - apiKey: Your Intercom API key
    ///    - appId: Your Intercom Application ID
    public init(apiKey: String, appId: String) {
        Intercom.setApiKey(apiKey, forAppId: appId)
    }
    
    /// Required for the ForethoughtPlugin Protocol. Chooses whether to show the Intercom Plugin on launch, based on the resumeConversation parameter
    public func showPluginOnLaunch() -> Bool {
        guard self.resumeSetting != .alwaysStartNewConversation else {
            return false
        }
        
        if Intercom.unreadConversationCount() == 0 {
            return false
        } else {
            Intercom.present()
            return true
        }
    }
    
    /// Informs the plugin that the Forethought screen was shown.
    public func forethoughtViewLoaded(viewController: UIViewController) {
        self.forethoughtVC = viewController
    }
    
    /// Required for the ForethoughtPlugin Protocol. Informs the plugin that Forethought would like to handoff to Intercom.
    public func forethoughtHandoffRequested(handoffData: ForethoughtHandoffData) {
        let unreadCount = Intercom.unreadConversationCount()
        if unreadCount > 0 && self.resumeSetting == .showForUnreadMessage {
            Intercom.present()
        } else {
            Intercom.presentMessageComposer(handoffData.question)
        }
        
        ForethoughtSDK.sendHandoffResponse(success: true)
    }

}
