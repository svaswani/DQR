//
//  NetHelper.swift
//  QRCodeGen
//
//  Created by Nick Mosher on 1/30/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

let server = "129.21.104.129"
let port = 4000

var singleton: NetHelper?

class NetHelper : NSObject, NSStreamDelegate {
    
var inputStream: NSInputStream?
var outputStream: NSOutputStream?
    
    override init() {
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
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        
        print("Callback started")
        
        // The input stream is the only stream we resistered as a delegate to, but this is a safety check.
        if aStream == inputStream {
            
            print("Callback is from inputStream")
            
            // Perform different actions based on the event code.
            switch eventCode {
                
            case NSStreamEvent.HasBytesAvailable:
                
                print("NSStreamEvent has bytes available")
                
                // Create a buffer to store the read data into.
                var buffer = [UInt8](count: 4096, repeatedValue: 0)
                
                // While the input stream still has data, continue reading it.
                while ((inputStream?.hasBytesAvailable) != nil) {
                    
                    // Read available bytes into the buffer and return the length of bytes read.
                    let len = inputStream?.read(&buffer, maxLength: buffer.count)
                    if(len > 0) {
                        
                        // Convert the bytes in the buffer to a string using UTF8.
                        let output = NSString(bytes: &buffer, length: buffer.count, encoding: NSUTF8StringEncoding)
                        
                        // If the output contains data, print it.
                        if output != "" {
                            print("Server said: \(output)")
                        }
                    }
                }
                
                break;
            default:
                print("Received stream event: \(eventCode.rawValue)")
            }
        }
    }
}
