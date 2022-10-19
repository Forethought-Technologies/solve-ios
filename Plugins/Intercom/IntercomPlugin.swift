//
//  IntercomPlugin.swift
//  Plugins
//
//  Created by Matthew Knippen on 10/5/22.
//

import Forethought
import Intercom
import UIKit

/// When Intercom has an open or unread conversation, choose what you would like to happen when the user asks for support
public enum IntercomResumeConversationSetting {
    ///Even if there is an open or unread message, always launch Forethought
    case alwaysStartNewConversation
    ///Default. If there's an unread message from an agent, show it. If there's an open conversation, prompt them
    case showForUnreadMessage
}

public class IntercomPlugin: ForethoughtPlugin {
    public var pluginName = "intercom"
    
    weak var forethoughtVC: UIViewController?
    
    let resumeSetting: IntercomResumeConversationSetting = .showForUnreadMessage
    
    public init(apiKey: String, appId: String) {
        Intercom.setApiKey(apiKey, forAppId: appId)
    }
    
    func loginToIntercom(userId: String?) {
        if let userId = userId {
            Intercom.registerUser(withUserId: userId)
        } else {
            Intercom.registerUnidentifiedUser()
        }
    }
    
    public func showPluginOnLaunch() -> Bool {
        guard self.resumeSetting != .alwaysStartNewConversation else {
            return false
        }
        
        let unreadCount = Intercom.unreadConversationCount()
        if unreadCount == 0 {
            return false
        } else {
            Intercom.presentMessenger()
            return true
        }
    }
    
    public func forethoughtViewLoaded(viewController: UIViewController) {
        self.forethoughtVC = viewController
    }
    
    public func forethoughtHandoffRequested(handoffData: ForethoughtHandoffData) {
        let unreadCount = Intercom.unreadConversationCount()
        if unreadCount > 0 && self.resumeSetting == .showForUnreadMessage {
            Intercom.presentMessenger()
        } else {
            Intercom.presentMessageComposer(handoffData.question)
        }
    }

}
