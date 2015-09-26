//
//  ViewController.swift
//  tally
//
//  Created by Aniruddha Nadkarni on 9/25/15.
//  Copyright © 2015 Aniruddha Nadkarni. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var backCam: AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Check that the device that we're using has video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Make sure this backCam is the back camera
                if (device.position == AVCaptureDevicePosition.Back) {
                    backCam = device as? AVCaptureDevice
                }
            }
        }
        
        if backCam != nil {
            beginSession()
        }
    }
    
    func beginSession() {
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: backCam))
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
