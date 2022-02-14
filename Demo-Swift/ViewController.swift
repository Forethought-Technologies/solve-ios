//
//  ViewController.swift
//  Demo-Swift
//
//  Created by Matthew Knippen on 12/22/21.
//

import UIKit
import Forethought

class ViewController: UIViewController, ForethoughtDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    @IBAction func contactSupportTapped(_ sender: UIButton) {
        ForethoughtSDK.delegate = self
        ForethoughtSDK.show()
    }
    
    
    //this is completely optional. Use this if you want to support an external integration, such as Zendesk
    //if not needed, remove this, and the forethoughtVC.delegate = self line above
    func startChatRequested(handoffData: ForethoughtHandoffData) {
        print("Chat Requested: \(handoffData)")
    }

}

