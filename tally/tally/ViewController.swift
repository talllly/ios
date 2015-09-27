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
    
    var backCam: AVCaptureDevice?
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var recaptureButton: UIButton!
    
    @IBAction func recaptureButtonAction(sender: AnyObject) {
        setupImagePicker()
        UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            self.recaptureButton.transform = CGAffineTransformMakeTranslation(0, 200)
            }) { (bool) -> Void in
        }
    }
    
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
            self.recaptureButton.layer.shadowColor = UIColor.grayColor().CGColor
            self.recaptureButton.layer.shadowOffset = CGSizeMake(0, 1.0)
            self.recaptureButton.layer.shadowOpacity = 1.0
            self.recaptureButton.layer.shadowRadius = 8.0
            self.recaptureButton.layer.cornerRadius = 5.0
            recaptureButton.alpha = 0.0
            
            self.recaptureButton.transform = CGAffineTransformMakeTranslation(0, 200)
        }
        
        setupImagePicker()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("Picker was cancelled")
        picker.dismissViewControllerAnimated(true, completion: nil)
        recaptureButton.alpha = 1.0
        UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            self.recaptureButton.transform = CGAffineTransformMakeTranslation(0, 0)
            }) { (bool) -> Void in
        }
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
                        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                        let cvImage = image
                        
                        print("Image = \(cvImage)")
                        imageView.image = cvImage
                        let numFaces = CVWrapper.howManyFaces(image)
                        print("THERE ARE: \(numFaces) faces")
                    }
                    
                }
            
                picker.dismissViewControllerAnimated(true, completion: nil)
            }
            recaptureButton.alpha = 1.0
            UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                self.recaptureButton.transform = CGAffineTransformMakeTranslation(0, 0)
                }) { (bool) -> Void in
            }
    }
    
    func setupImagePicker() {
        imagePickerController = UIImagePickerController()
        
        if let thisController = imagePickerController {
            thisController.sourceType = .Camera
            
            thisController.mediaTypes = [kUTTypeImage as String]
            
            thisController.allowsEditing = true
            thisController.delegate = self
            presentViewController(thisController, animated: true, completion: nil)
        }
    }
}
