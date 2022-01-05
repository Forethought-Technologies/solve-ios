//
//  ViewController.swift
//  Demo-Swift
//
//  Created by Matthew Knippen on 12/22/21.
//

import UIKit
import Forethought

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func contactSupportTapped(_ sender: UIButton) {

        let API_KEY = "__YOUR_KEY_HERE__"
        
        let dataParameters = ["language":"EN", "tracking-email":"test@ft.ai"]
        let forethoughtVC = ForethoughtViewController(API_KEY: API_KEY, dataParameters: dataParameters)
        forethoughtVC.title = "Custom Title Here"
        
        //you can present as a modal, or onto your navigation stack, whichever you prefer
        self.present(forethoughtVC, animated: true, completion: nil)
  //    navigationController?.pushViewController(forethoughtView, animated: false)
    }


}

