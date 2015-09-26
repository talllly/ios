//
//  ViewController.swift
//  tally
//
//  Created by Aniruddha Nadkarni on 9/25/15.
//  Copyright © 2015 Aniruddha Nadkarni. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class ViewController: UIViewController,
UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    var CVImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    
    var backCam: AVCaptureDevice?
    
    var loadedBefore = false
    
    var imagePickerController: UIImagePickerController?
    
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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if loadedBefore {
            return;
        } else {
            loadedBefore = true
        }
        
        imagePickerController = UIImagePickerController()
        
        if let thisController = imagePickerController {
            thisController.sourceType = .Camera
            
            thisController.mediaTypes = [kUTTypeImage as String]
            
            thisController.allowsEditing = true
            thisController.delegate = self
            presentViewController(thisController, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("Picker was cancelled")
        //picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String: AnyObject]){
            
            print("Picker returned successfully")
            
            let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
            
            if let type:AnyObject = mediaType{
                
                if type is String{
                    let stringType = type as! String
                    
                    if stringType == kUTTypeMovie as String{
                        let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
                        if let url = urlOfVideo{
                            print("Video URL = \(url)")
                        }
                    }
                        
                    else if stringType == kUTTypeImage as String{
                        /* Let's get the metadata. This is only for images. Not videos */
                        let metadata = info[UIImagePickerControllerMediaMetadata]
                            as? NSDictionary
                        if let theMetaData = metadata{
                            let image = info[UIImagePickerControllerOriginalImage]
                                as? UIImage
                            if let theImage = image {
                                CVImage = theImage
                                print("Image Metadata = \(theMetaData)")
                                print("Image = \(theImage)")
                            }
                        }
                    }
                    
                }
            }
            
            picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
