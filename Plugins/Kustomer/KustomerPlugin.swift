//
//  KustomerPlugin.swift
//  Plugins
//
//  Created by Matthew Knippen on 1/19/22.
//

import Forethought
import KustomerChat
import UIKit

/// When Kustomer has an open or unread conversation, choose what you would like to happen when the user asks for support
public enum KustomerResumeConversationSetting {
    ///Even if there is an open or unread message, always launch Forethought
    case alwaysStartNewConversation
    ///Default. If there's an unread message from an agent, show it. If there's an open conversation, prompt them
    case showForUnreadMessagePromptForOpen
    ///If there's an open conversation, show Kustomer
    case showForOpenConversation
    ///If there's an unread or an open conversation, prompt the user to select
    case promptIfOpenOrUnread
}

public class KustomerPlugin: ForethoughtPlugin {
    weak var forethoughtVC: UIViewController?
    /// Choose the initial question you would like to present when loading Kustomer (this comes from the agent)
    /// NOTE: This will only be used if we don't already have the conversation from Forethought to hand off to the user
    public var initialQuestion: String? = "Hello, how can I help you today?"
    /// When Kustomer has an open or unread conversation, choose what you would like to happen when the user asks for support.
    /// Default is .showForUnreadMessagePromptForOpen
    public var resumeConversation: KustomerResumeConversationSetting = .showForUnreadMessagePromptForOpen
    
    /// The integration name that connects Kustomer to Forethought. This should not be altered.
    public var pluginName = "kustomer"
    
    /// The number of open conversations available to the user via Kustomer. Fetched at launch
    var openConversationCount: Int = 0
    
    /// The number of open conversations with an unread message available to the user. Fetched at launch
    var unreadConversationCount: Int = 0
    
    /// Configures the Kustomer SDK and attaches it directly to Forethought
    ///
    ///  - Parameters:
    ///    - apiKey: Your Kustomer API Key
    ///    - options: Set custom settings for the Kustomer integration. See Kustomer documentation for more information.
    public init(apiKey: String, options: KustomerOptions? = nil) {
        let _ = Kustomer.configure(apiKey: apiKey, options: options, launchOptions: nil)
        self.getConversationCounts()
    }
    
    // Fetches the conversation count and the unread count via the Kustomer SDK.
    private func getConversationCounts() {
        KustomerClient.shared.getOpenConversationCount { result in
            do {
                self.openConversationCount = try result.get()
            } catch {
                self.openConversationCount = 0
            }
        }
        
        KustomerClient.shared.getUnreadCount { result in
            do {
                self.unreadConversationCount = try result.get()
            } catch {
                self.unreadConversationCount = 0
            }
        }
    }
    
    /// For the ForethoughtPlugin Protocol. Chooses whether to show the Kustomer Plugin on launch, based on the resumeConversation parameter
    @objc public func showPluginOnLaunch() -> Bool {
        guard resumeConversation == .showForUnreadMessagePromptForOpen || resumeConversation == .showForOpenConversation else {
            return false
        }
        
        if resumeConversation == .showForUnreadMessagePromptForOpen && unreadConversationCount > 0 {
            Kustomer.show(preferredView: .activeChat)
            return true
        } else if resumeConversation == .showForOpenConversation && openConversationCount > 0 {
            Kustomer.show(preferredView: .activeChat)
            return true
        }
        
        return false
    }
    
    /// For the ForethoughtPlugin Protocol
    @objc public func forethoughtViewLoaded(viewController: UIViewController) {
        self.forethoughtVC = viewController
    }
    
    /// For the ForethoughtPlugin Protocol. Prompts the user to continue a conversation based on the resumeConversation parameter
    @objc public func forethoughtViewDidAppear() {
        if resumeConversation == .showForUnreadMessagePromptForOpen && openConversationCount > 0 {
            self.promptToContinueConversation(openConversationCount: openConversationCount)
        } else if resumeConversation == .promptIfOpenOrUnread && openConversationCount > 0 {
            self.promptToContinueConversation(openConversationCount: openConversationCount)
        }
    }
    
    /// For the ForethoughtPlugin Protocol. Forethought has requested a handoff to Kustomer. Hides the Forethought SDK and shows Kustomer with a new conversation.
    @objc public func forethoughtHandoffRequested(handoffData: ForethoughtHandoffData) {
        print("Handoff Requested: \(handoffData)")
        ForethoughtSDK.hide(animated: false) {
            self.startNewConversation(handoffData: handoffData)
        }
    }
    
    //MARK: - Helper Methods
    func startNewConversation(handoffData: ForethoughtHandoffData) {
        if let email = handoffData.email {
            Kustomer.chatProvider.describeCurrentCustomer(email: email)
        }
        
        //if we have the conversation or question that the user asked Forethought, let's send that along to Kustomer
        //The needs to make a quick API call before being shown. If we don't have the question, let's just show it directly
        if let question = handoffData.question {
            Kustomer.chatProvider.createConversation(firstCustomerMessage: question) { result in
                switch result {
                case .success(let item):
                    if let id = item.conversation.id {
                        ForethoughtSDK.hide(animated: false) {
                            Kustomer.openConversation(id: id, animated: true, completion: nil)
                        }
                    } else {
                        self.fallbackStartConversation()
                    }
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    self.fallbackStartConversation()
                }
            }
        } else {
            self.fallbackStartConversation()
        }
    }
    
    /// If creating a new conversation and setting the initial question fails in someway, show via the traditional method
    func fallbackStartConversation() {
        ForethoughtSDK.hide(animated: false) {
//            var initialMessages: [String] = []
//            if let initialQuestion = self.initialQuestion {
//                initialMessages.append(initialQuestion)
//            }
//
//            Kustomer.openNewConversation(initialMessages: initialMessages, afterCreateConversation: { conversation in
//                //This isn't called until the user manually sends the first message
//                print("Conversation Created: \(conversation)")
//            }, animated: false)
            
            var message: KUSInitialMessage? = nil
            if let initialQuestion = self.initialQuestion {
                message = KUSInitialMessage(body: initialQuestion, direction: .user)
            }
            
            KustomerClient.shared.startNewConversation(initialMessage: message, afterCreateConversation: { conversation in
                print("Conversation Created: \(conversation)")
            }, animated: false)
        }
    }
    
    func promptToContinueConversation(openConversationCount: Int) {
        var unreadMessageText = ""
        if unreadConversationCount > 0 {
            unreadMessageText = " with an unread message"
        }
        
        let controller = UIAlertController(title: "Continue Conversation?", message: "You have an open conversation with a chat agent\(unreadMessageText). Would you like to continue that conversation, or start a new one?", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue Conversation", style: .default) { action in
            ForethoughtSDK.hide(animated: false) {
                self.continueConversation(openConversationCount: openConversationCount)

            }
        }
        let newAction = UIAlertAction(title: "New Conversation", style: .default) { action in
            print("new")
        }
        controller.addAction(continueAction)
        controller.addAction(newAction)
        self.forethoughtVC!.present(controller, animated: true, completion: nil)
    }
    
    func continueConversation(openConversationCount: Int) {
        if openConversationCount == 1 {
            Kustomer.show(preferredView: .activeChat)
        } else {
            Kustomer.show(preferredView: .chatHistory)
        }
    }

}
