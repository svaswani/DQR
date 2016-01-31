//
//  NetHelper.swift
//  QRCodeGen
//
//  Created by Nick Mosher on 1/30/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import Starscream

let server = "129.21.104.129"
let port = 4000

var inputStream: NSInputStream?
var outputStream: NSOutputStream?

var singleton: NetHelper?

var socket = WebSocket(url: NSURL(string: server)!)

class NetHelper : NSObject, NSStreamDelegate, WebSocketDelegate {
    
    override init() {
        super.init()
        
        NSStream.getStreamsToHostWithName(server, port: port, inputStream: &inputStream, outputStream: &outputStream)
        
        socket.delegate = self as WebSocketDelegate
        socket.connect()
        
        outputStream?.open()
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
    
    func websocketDidConnect(socket: WebSocket) {
        print("Websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("Websocket is disconnected: \(error?.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("Got some text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("Got some data: \(data.length)")
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