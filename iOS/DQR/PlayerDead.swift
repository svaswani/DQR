//
//  PlayerDead.swift
//  DQR
//
//  Created by Apple on 1/31/16.
//  Copyright © 2016 Team DQR. All rights reserved.
//

import UIKit

class PlayerDead: UIViewController {
    
    @IBOutlet weak var nextGameButton: UIButton!
    
//    @IBAction func didClickNewGame(sender: AnyObject) {
//        self.performSegueWithIdentifier("goToNewGame", sender: self)
//    }
    override func viewDidLoad() {
        nextGameButton.layer.cornerRadius = 10
        nextGameButton.clipsToBounds = true
    }
}

