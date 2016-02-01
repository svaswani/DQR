//
//  QRDisplayViewController.swift
//  DQR
//
//  Created by Wm. Blake Sullivan on 1/31/16.
//  Copyright © 2016 Team DQR. All rights reserved.
//

import UIKit

class QRDisplayViewController : UIViewController {
    @IBOutlet weak var QRImage: UIImageView!
    
    let myManager: PlayerManager? = PlayerManager.getPlayerManager()
    
    func updateImage() {
        if myManager!.thisPlayer != nil {
            QRImage.image = myManager!.thisPlayer?.qrImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateImage()
    }
    

    @IBAction func exitView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
