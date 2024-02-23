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
    }

    @IBAction func contactSupportTapped(_ sender: UIButton) {
        ForethoughtSDK.delegate = self
        ForethoughtSDK.show()
    }


    func widgetClosed() {
        ForethoughtSDK.hide(animated: true) {
            print("forethought - widget closed")
        }
    }

    func startChatRequested(handoffData: ForethoughtHandoffData) {
        ForethoughtSDK.hide(animated: true) {
            print("forethought - \(handoffData)")
            ForethoughtSDK.sendHandoffResponse(success: true)
        }
    }

    func widgetError(errorData: ForethoughtErrorData) {
        ForethoughtSDK.hide(animated: true) {
            print("forethought - \(errorData.error)")
        }
    }
}
