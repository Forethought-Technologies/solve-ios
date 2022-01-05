//
//  ForethoughtContainerViewController.swift
//  Demo-SwiftUI
//
//  Created by Matthew Knippen on 12/23/21.
//

import SwiftUI
import UIKit
import Forethought

struct ForethoughtContainerViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        //prod demo key
        let API_KEY = "__YOUR_KEY_HERE__"

        let dataParameters = ["language":"EN", "tracking-email":"test@ft.ai"]
        let forethoughtVC = ForethoughtViewController(API_KEY: API_KEY, dataParameters: dataParameters)
        forethoughtVC.title = "Get Support"
        return forethoughtVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //no updating needed
    }
    
}
