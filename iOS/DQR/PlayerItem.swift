//
//  PlayerItem.swift
//  DQR
//
//  Created by Apple on 1/30/16.
//  Copyright © 2016 Team DQR. All rights reserved.
//

import UIKit

class PlayerItem: NSObject, NSCoding {
    
    let name: String
    let qrImage: UIImage
    var scanned: Bool
    
    init(name: String) {
        self.name = name
        self.qrImage = PlayerItem.generateQR(name)
        self.scanned = false
    }
    
    // Generates a QR code from a string and returns a UIImage.
    class func generateQR(text: String) -> UIImage {
        
        // Convert string data into a form usable for QR generation.
        let data = text.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        
        // Create a filter that will parse the text into a QR image.
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        //Set filter properties to "tune" QR image.
        filter!.setValue(data, forKey: "inputMessage")
        filter!.setValue("M", forKey: "inputCorrectionLevel")
        
        
        
        // Return the generated QR image.
        return UIImage(CIImage: (filter?.outputImage)!)
    }
    
    let nameKey = "name"
    let qrImageKey = "qrImage"
    let scannedKey = "scanned"
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: nameKey)
        aCoder.encodeObject(qrImage, forKey: qrImageKey)
        aCoder.encodeObject(scanned, forKey: scannedKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey(nameKey) as! String
        qrImage = aDecoder.decodeObjectForKey(qrImageKey) as! UIImage
        scanned = aDecoder.decodeObjectForKey(scannedKey) as! Bool
    }
}
