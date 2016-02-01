//
//  NetHelper.swift
//  QRCodeGen
//
//  Created by Nick Mosher on 1/30/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

let server = "starfighter.csh.rit.edu"
let port = 4000

var singleton: NetHelper?

class NetHelper : NSObject, NSStreamDelegate {
    
var inputStream: NSInputStream?
var outputStream: NSOutputStream?
    
    private override init() {
        super.init()
        
        NSStream.getStreamsToHostWithName(server, port: port, inputStream: &inputStream, outputStream: &outputStream)
        
        inputStream?.open()
        outputStream?.open()
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            let bufferSize = 1024
            var inputBuffer = Array<UInt8>(count: bufferSize, repeatedValue: 0)
            while true {
                /* Uncomment to get byte count ** let bytesRead = */self.inputStream!.read(&inputBuffer, maxLength: bufferSize)
                
                let responseString = NSString(bytes: inputBuffer, length: inputBuffer.count, encoding: NSUTF8StringEncoding) as! String
                print("Read data from stream: \(responseString)")
                
                //Notify the game manager of the server response.
                GameHelper.onServerCommandReceived(responseString)
            }
        }
    }
    
    class func getNetHelper() -> NetHelper {
        
        if singleton == nil {
            singleton = NetHelper()
        }
        
        return singleton!
    }
    
    func sendToServer(text: String) {
        
        print("Sending \(text) to server.")
        let buffer: [UInt8] = Array(text.utf8)
        outputStream?.write(buffer, maxLength: text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    }
}
