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
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    @IBOutlet var imageView: UIImageView!
    
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
        configureCamera()
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
    
    func configureCamera() {
        if let cam = backCam {
            do {
                try cam.lockForConfiguration()
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
            }
            cam.focusMode = .Locked
            cam.unlockForConfiguration()
        }
    }
    
//    func focusTo(value: Float) {
//        if let cam = backCam {
//            do {
//                try cam.lockForConfiguration()
////                cam.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
////                    //
////                })
//                currentDevice.focusPointOfInterest = tap.locationInView(self)
//                cam.unlockForConfiguration()
//            } catch let error as NSError {
//                print("error: \(error.localizedDescription)")
//            }
//        }
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let aTouch = touches.first as UITouch?
        //let touchPercent = aTouch!.locationInView(self.view).x / screenWidth
        if let cam = backCam {
            do {
                try cam.lockForConfiguration()
                //                cam.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
                //                    //
                //                })
                cam.focusPointOfInterest = aTouch!.locationInView(self.view)
                cam.focusMode = AVCaptureFocusMode.AutoFocus
                cam.unlockForConfiguration()
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
            }
        }
        //focusTo(Float(touchPercent))
        print("touched\n")
    }
    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let aTouch = touches.first as UITouch?
//        let touchPercent = (aTouch?.locationInView(self.view).x)! / screenWidth
//        focusTo(Float(touchPercent))
//        print("moved\n")
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

