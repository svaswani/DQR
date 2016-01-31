//
//  ServerViewController.swift
//  DQR
//
//  Created by Apple on 1/31/16.
//  Copyright © 2016 Team DQR. All rights reserved.
//

import UIKit

class ServerViewController : UIViewController {
    
    let net: NetHelper = NetHelper.getNetHelper()
    
    @IBAction func buttonTop(sender: AnyObject) {
        
        net.sendToServer("Hello from iOS!\n")
    }
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        
        
    }
}