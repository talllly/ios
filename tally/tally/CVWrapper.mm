//
//  CVWrapper.m
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "CVWrapper.h"
#import "UIImage+OpenCV.h"


@implementation CVWrapper

+ (UIImage *) howManyFaces: (UIImage*) inputImage
{
    if ([inputImage isKindOfClass: [UIImage class]]) {
        return [inputImage CVCountFaces];
    }
    else {
        return inputImage;
    }
}

@end
