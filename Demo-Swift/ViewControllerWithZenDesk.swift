//
//  ViewController.swift
//  Demo-Swift
//
//  Created by Matthew Knippen on 12/22/21.
//

import UIKit
import Forethought

//if you'd like to use Zendesk, uncomment these
//import ChatSDK
//import ChatProvidersSDK
//import MessagingSDK

class ViewControllerWithZenDesk: UIViewController, ForethoughtDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Zendesk only, replace with your Zendesk account info
//        Chat.initialize(accountKey: "ZENDESK_ACCOUNT_KEY", appId: "ZENDESK_APP_ID")
    }
    
    @IBAction func contactSupportTapped(_ sender: UIButton) {

        let API_KEY = "__YOUR_KEY_HERE__"
        
//        let configParameters = ["language":"EN", "tracking-email":"test@ft.ai"]

        let dataParameters = ["language":"EN", "tracking-email":"test@ft.ai"]
        let forethoughtVC = ForethoughtViewController(API_KEY: API_KEY, dataParameters: dataParameters)
        forethoughtVC.delegate = self
        forethoughtVC.title = "Custom Title Here"
        self.present(forethoughtVC, animated: true, completion: nil)
  //    navigationController?.pushViewController(forethoughtView, animated: false)
    }
    
    
    //this is completely optional. Use this if you want to support an external integration, such as Zendesk
    //if not needed, remove this, and the forethoughtVC.delegate = self line above
    func startChatRequested(name: String?, email: String?, question: String?) {
//        do {
//            // Configure Zendesk Widget
//            let messagingConfiguration = MessagingConfiguration()
//            let chatConfiguration = ChatConfiguration()
//            chatConfiguration.isPreChatFormEnabled = false
//            chatConfiguration.isAgentAvailabilityEnabled = false
//
//            // update Chat instance
//            let chatAPIConfiguration = ChatAPIConfiguration()
//            chatAPIConfiguration.visitorInfo = VisitorInfo(name: name ?? "", email: email ?? "", phoneNumber: "")
//            Chat.instance?.configuration = chatAPIConfiguration
//
//            // send question
//            Chat.connectionProvider?.connect()
//            Chat.chatProvider?.sendMessage(question ?? "")
//            Chat.connectionProvider?.disconnect()
//
//            // Build and present Zendesk Chat
//            let chatEngine = try ChatEngine.engine()
//            let viewController = try Messaging.instance.buildUI(engines: [chatEngine], configs: [messagingConfiguration, chatConfiguration])
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
//        catch {
//            print("Could not initiate Zendesk chat")
//        }
    }

}

