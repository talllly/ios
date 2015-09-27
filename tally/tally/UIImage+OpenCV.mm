//
//  UIImage+OpenCV.mm
//  OpenCVClient
//
//  Created by Washe on 01/12/2012.
//  Copyright 2012 Washe / Foundry. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//
//  adapted from
//  http://docs.opencv.org/doc/tutorials/ios/image_manipulation/image_manipulation.html#opencviosimagemanipulation

#import "UIImage+OpenCV.h"
#import "MacTypes.h"
#include <string>
#include <opencv2/opencv.hpp>


@implementation UIImage (OpenCV)

-(cv::Mat)CVMat
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (cv::Mat)CVMat3
{
    cv::Mat result = [self CVMat];
    cv::cvtColor(result , result , CV_RGBA2RGB);
    return result;

}

-(UIImage *)CVCountFaces
{
    
    //Location of the classifiers of faces
    //REPLACE IT WITH THE APROPRIATE PATH
    //Create the classifiers
    cv::CascadeClassifier faceCascade;
    
    //The captured frame
    cv::Mat frame = [self CVMat];
    if(frame.empty())
    {
        std::cerr << "Could not load image" << std::endl;
        return self;
    }
    
    //Load the classifiers
    
    NSURL *filepath = [[NSBundle mainBundle] URLForResource:@"haarcascade_frontalface_alt2" withExtension:@"xml"];
    if (!faceCascade.load( std::string([filepath fileSystemRepresentation]) ))
    {
        std::cerr << "Could not load face classifier" << std::endl;
        return self;
    }
    
    
    //This will contain the output of the face detector
    std::vector<cv::Rect> faces;
    
    //Preprocess the image
    cv::Mat frameGray;
    cv::cvtColor( frame, frameGray, CV_BGR2GRAY );
    cv::equalizeHist( frameGray, frameGray );
    
    //Detect the face
    faceCascade.detectMultiScale( frameGray, faces, 1.1, 2, 0, cv::Size(20,20), cv::Size(1000,1000));
    
//    //Draw circles around each face
//    for( int i = 0; i < faces.size(); i++ )
//    {
//        Point center = 2( faces[i].x + faces[i].width*0.5, faces[i].y + faces[i].height*0.5 );
//        ellipse( image, center, Size( faces[i].width*0.5, faces[i].height*0.5), 0, 0, 360, Scalar( 255, 0, 255 ), 4, 8, 0 );
//    }
    std::cerr << "I found " << faces.size() << " faces." << std::endl;
    return self;
}

+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat
{
    return [[UIImage alloc] initWithCVMat:cvMat];
}

- (id)initWithCVMat:(const cv::Mat&)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);

        // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                              //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );                     
    
        // Getting UIImage from CGImage
    self = [self initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return self;
}



@end
