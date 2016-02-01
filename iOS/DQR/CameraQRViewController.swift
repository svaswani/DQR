//
//  ViewController.swift
//  DQR
//
//  Created by Nick Mosher on 1/28/16.
//  Copyright © 2016 Team DQR. All rights reserved.
//

import UIKit
import AVFoundation

class CameraQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var thisPlayer:PlayerItem?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToQR" {
            let qrVC = segue.destinationViewController as! QRDisplayViewController
            if let player = thisPlayer {
                qrVC.thisPlayer = player
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get an instance of the AVCaptureDevice with video as the default media type.
        let captureDevice:AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of AVCaptureDeviceInput using the device object.
        let inputDevice: AnyObject!
        do {
            inputDevice = try AVCaptureDeviceInput(device: captureDevice)
        } catch _ {
            print("Failed to initialize the AVCaptureDeviceInput")
            inputDevice = nil
        }
        
        // Initialize the capture session object.
        captureSession = AVCaptureSession()
        
        // Set the input device on the input capture session.
        captureSession?.addInput(inputDevice as! AVCaptureInput)
        
        // Initialize an AVCaptureMetadataOutput object and set it as the output device for the capture session.
        let captureMetatdataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetatdataOutput)
        
        // Set this ViewController as the delegate for the MetadataOutput.
        captureMetatdataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetatdataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture
        captureSession?.startRunning()
        
        // Initialize QR Code Frame to hightlight the QR Code.
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjecs array is not null and contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            
            qrCodeFrameView?.frame = CGRectZero
            return
        }
        
        // Get the metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            
            // If the metadata object is a barcode object, parse the boudary and contained data.
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            
            qrCodeFrameView?.frame = barCodeObject.bounds
            if metadataObj.stringValue != nil {
                
                // DO SOMETHING WITH THE READ QR TEXT DATA HERE
                // metadataObj.stringValue
                print("Read QR: \(metadataObj.stringValue)")
            }
        }
    }
    
}

