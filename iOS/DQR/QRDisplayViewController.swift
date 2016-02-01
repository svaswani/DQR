//
//  QRDisplayViewController.swift
//  DQR
//
//  Created by Wm. Blake Sullivan on 1/31/16.
//  Copyright © 2016 Team DQR. All rights reserved.
//

import UIKit

class QRDisplayViewController : UICollectionViewController {
    @IBOutlet weak var QRImage: UIImageView!
    
    func updateImage() {
        if thisPlayer != nil {
            QRImage.image = thisPlayer?.qrImage
        }
    }
    
    var thisPlayer:PlayerItem?

    @IBAction func exitView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
